-- Mini Files utilities and enhancements

local M = {}

-- Filter for hiding dot files
M.filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

-- Filter for showing all files
M.filter_show = function(fs_entry)
  return true
end

-- Toggle dotfiles visibility
M.toggle_dotfiles = function()
  local MiniFiles = require("mini.files")
  local show_dotfiles = not M.get_dotfiles_state()
  local new_filter = show_dotfiles and M.filter_show or M.filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
  M.set_dotfiles_state(show_dotfiles)
end

-- Get current dotfiles state
M.get_dotfiles_state = function()
  return _G.mini_files_dotfiles_state or false
end

-- Set dotfiles state
M.set_dotfiles_state = function(state)
  _G.mini_files_dotfiles_state = state
end

-- Set current working directory to entry's parent
M.set_cwd = function()
  local MiniFiles = require("mini.files")
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.chdir(vim.fs.dirname(path))
end

-- Open entry with system default application
M.ui_open = function()
  local MiniFiles = require("mini.files")
  vim.ui.open(MiniFiles.get_fs_entry().path)
end

-- Copy absolute path to register
M.yank_path = function()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, entry.path)
end

-- Copy directory path to register
M.yank_dir = function()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, vim.fs.dirname(entry.path))
end

-- Copy file name to register
M.yank_fname = function()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.name then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, entry.name)
end

-- Copy relative path to register
M.yank_relpath = function()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  local cwd = vim.fn.getcwd()
  local rel = vim.fn.fnamemodify(entry.path, ":.")
  vim.fn.setreg(vim.v.register, rel)
end

-- Split window helper
M.map_split = function(buf_id, lhs, direction)
  local MiniFiles = require("mini.files")
  local rhs = function()
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)
    MiniFiles.set_target_window(new_target)
  end
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

-- Toggle preview
M.toggle_preview = function()
  local MiniFiles = require("mini.files")
  MiniFiles.config.windows.preview = not MiniFiles.config.windows.preview
  MiniFiles.refresh({ windows = { preview = MiniFiles.config.windows.preview } })
end

-- Setup keymaps for MiniFiles buffer
M.setup_keymaps = function(buf_id)
  -- Navigation and utility
  vim.keymap.set("n", "_", M.set_cwd, { buffer = buf_id, desc = "Set cwd" })
  vim.keymap.set("n", "g.", M.toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })
  vim.keymap.set("n", "gX", M.ui_open, { buffer = buf_id, desc = "OS open" })
  vim.keymap.set("n", "<leader>cc", M.yank_path, { buffer = buf_id, desc = "Copy absolute path" })
  vim.keymap.set("n", "<leader>cd", M.yank_dir, { buffer = buf_id, desc = "Copy directory path" })
  vim.keymap.set("n", "<leader>cf", M.yank_fname, { buffer = buf_id, desc = "Copy file name" })
  vim.keymap.set("n", "<leader>cr", M.yank_relpath, { buffer = buf_id, desc = "Copy relative path" })

  -- Split windows
  M.map_split(buf_id, "<C-s>", "belowright vertical")
  M.map_split(buf_id, "<C-h>", "belowright horizontal")
  M.map_split(buf_id, "<C-t>", "tab")

  -- Preview
  vim.keymap.set("n", "<C-p>", M.toggle_preview, { buffer = buf_id, desc = "Toggle preview" })
end

-- Git status utilities
M.setup_git_status = function()
  local nsMiniFiles = vim.api.nvim_create_namespace("mini_files_git")
  local autocmd = vim.api.nvim_create_autocmd
  local MiniFiles = require("mini.files")

  -- Cache for git status
  local gitStatusCache = {}
  local cacheTimeout = 2000 -- in milliseconds
  local uv = vim.uv or vim.loop

  -- Check if path is symlink
  local function isSymlink(path)
    local stat = uv.fs_lstat(path)
    return stat and stat.type == "link"
  end

  -- Map git status to symbols
  local function mapSymbols(status, is_symlink)
    local statusMap = {
      [" M"] = { symbol = require("utils.icons").git.modified, hlGroup = "MiniDiffSignChange" },
      ["M "] = { symbol = require("utils.icons").git.staged, hlGroup = "MiniDiffSignChange" },
      ["R "] = { symbol = require("utils.icons").git.renamed, hlGroup = "MiniDiffSignChange" },
      ["A "] = { symbol = require("utils.icons").git.added, hlGroup = "MiniDiffSignAdd" },
      ["??"] = { symbol = require("utils.icons").git.untracked, hlGroup = "MiniDiffSignAdd" },
      ["!!"] = { symbol = require("utils.icons").git.ignored, hlGroup = "MiniDiffSignIgnored" },
      ["D "] = { symbol = require("utils.icons").git.deleted, hlGroup = "MiniDiffSignDelete" },
      ["UU"] = { symbol = require("utils.icons").git.conflict, hlGroup = "MiniDiffSignDelete" },
      ["MM"] = { symbol = "≠", hlGroup = "MiniDiffSignChange" },
      ["AA"] = { symbol = "≈", hlGroup = "MiniDiffSignAdd" },
      ["AM"] = { symbol = "⊕", hlGroup = "MiniDiffSignChange" },
      ["AD"] = { symbol = "-•", hlGroup = "MiniDiffSignChange" },
      ["U "] = { symbol = "‖", hlGroup = "MiniDiffSignDelete" },
      ["UA"] = { symbol = "⊕", hlGroup = "MiniDiffSignDelete" },
    }
    local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
    local gitSymbol = result.symbol
    local gitHlGroup = result.hlGroup
    local symlinkSymbol = is_symlink and "↩" or ""
    local combinedSymbol = (symlinkSymbol .. gitSymbol):gsub("^%s+", ""):gsub("%s+$", "")
    local combinedHlGroup = is_symlink and "MiniDiffSignDelete" or gitHlGroup
    return combinedSymbol, combinedHlGroup
  end

  -- Fetch git status
  local function fetchGitStatus(cwd, callback)
    local clean_cwd = cwd:gsub("^minifiles://%d+/", "")
    local function on_exit(content)
      if content.code == 0 then
        callback(content.stdout)
      end
    end
    vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = clean_cwd }, on_exit)
  end

  -- Update mini files with git status
  local function updateMiniWithGit(buf_id, gitStatusMap)
    vim.schedule(function()
      local nlines = vim.api.nvim_buf_line_count(buf_id)
      local cwd = vim.fs.root(buf_id, ".git")
      local escapedcwd = cwd and vim.pesc(cwd)
      escapedcwd = vim.fs.normalize(escapedcwd)

      for i = 1, nlines do
        local entry = MiniFiles.get_fs_entry(buf_id, i)
        if not entry then
          break
        end
        local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
        local status = gitStatusMap[relativePath]
        if status then
          local symbol, hlGroup = mapSymbols(status, isSymlink(entry.path))
          vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, 0, {
            sign_text = symbol,
            sign_hl_group = hlGroup,
            priority = 2,
          })
          local line = vim.api.nvim_buf_get_lines(buf_id, i - 1, i, false)[1]
          local nameStartCol = line:find(vim.pesc(entry.name)) or 0
          if nameStartCol > 0 then
            vim.api.nvim_buf_set_extmark(buf_id, nsMiniFiles, i - 1, nameStartCol - 1, {
              end_col = nameStartCol + #entry.name - 1,
              hl_group = hlGroup,
            })
          end
        end
      end
    end)
  end

  -- Parse git status output
  local function parseGitStatus(content)
    local gitStatusMap = {}
    for line in content:gmatch("[^\r\n]+") do
      local status, filePath = string.match(line, "^(..)%s+(.*)")
      local parts = {}
      for part in filePath:gmatch("[^/]+") do
        table.insert(parts, part)
      end
      local currentKey = ""
      for i, part in ipairs(parts) do
        if i > 1 then
          currentKey = currentKey .. "/" .. part
        else
          currentKey = part
        end
        if i == #parts then
          gitStatusMap[currentKey] = status
        else
          if not gitStatusMap[currentKey] then
            gitStatusMap[currentKey] = status
          end
        end
      end
    end
    return gitStatusMap
  end

  -- Update git status
  local function updateGitStatus(buf_id)
    if not vim.fs.root(buf_id, ".git") then
      return
    end
    local cwd = vim.fs.root(buf_id, ".git")
    local currentTime = os.time()
    if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
      updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
    else
      fetchGitStatus(cwd, function(content)
        local gitStatusMap = parseGitStatus(content)
        gitStatusCache[cwd] = {
          time = currentTime,
          statusMap = gitStatusMap,
        }
        updateMiniWithGit(buf_id, gitStatusMap)
      end)
    end
  end

  -- Clear cache
  local function clearCache()
    gitStatusCache = {}
  end

  -- Create augroup helper
  local function augroup(name)
    return vim.api.nvim_create_augroup("MiniFiles_" .. name, { clear = true })
  end

  -- Setup autocommands for git status
  autocmd("User", {
    group = augroup("start"),
    pattern = "MiniFilesExplorerOpen",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      updateGitStatus(bufnr)
    end,
  })

  autocmd("User", {
    group = augroup("close"),
    pattern = "MiniFilesExplorerClose",
    callback = function()
      clearCache()
    end,
  })

  autocmd("User", {
    group = augroup("update"),
    pattern = "MiniFilesBufferUpdate",
    callback = function(args)
      local bufnr = args.data.buf_id
      local cwd = vim.fs.root(bufnr, ".git")
      if gitStatusCache[cwd] then
        updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
      end
    end,
  })

  -- Define ignored highlight group
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.api.nvim_set_hl(0, "MiniDiffSignIgnored", { fg = "#6c7086" })
    end,
  })
end

return M
