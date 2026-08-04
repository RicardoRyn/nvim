local M = {}

-- Filter for showing all files
local function filter_show()
  return true
end

-- Get current dotfiles state
local function get_dotfiles_state()
  return _G.mini_files_dotfiles_state or false
end

-- Set dotfiles state
local function set_dotfiles_state(state)
  _G.mini_files_dotfiles_state = state
end

-- Toggle dotfiles visibility
local function toggle_dotfiles()
  local MiniFiles = require("mini.files")
  local show_dotfiles = not get_dotfiles_state()
  local new_filter = show_dotfiles and filter_show or M.filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
  set_dotfiles_state(show_dotfiles)
end

-- Set current working directory to entry's parent
local function set_cwd()
  local MiniFiles = require("mini.files")
  local path = (MiniFiles.get_fs_entry() or {}).path
  if path == nil then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.chdir(vim.fs.dirname(path))
end

-- Open entry with system default application
local function ui_open()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry()
  if entry == nil then
    return vim.notify("Cursor is not on valid entry", vim.log.levels.WARN)
  end
  local path = vim.fs.normalize(entry.path)
  if require("utils.system").is_win then
    os.execute('start "" "' .. path .. '"')
  else
    vim.ui.open(path)
  end
end

-- Copy absolute path
local function yank_path()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, vim.fs.normalize(entry.path))
end

-- Copy directory path
local function yank_dir()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, vim.fs.normalize(vim.fs.dirname(entry.path)))
end

-- Copy file name
local function yank_fname()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.name then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, entry.name)
end

-- Copy file name without extension
local function yank_fname_no_ext()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.name then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, vim.fn.fnamemodify(entry.name, ":r"))
end

-- Copy relative path
local function yank_relpath()
  local MiniFiles = require("mini.files")
  local entry = MiniFiles.get_fs_entry() or {}
  if not entry.path then
    return vim.notify("Cursor is not on valid entry")
  end
  vim.fn.setreg(vim.v.register, vim.fn.fnamemodify(vim.fs.normalize(entry.path), ":."))
end

-- Split window helper
local function map_split(buf_id, lhs, direction)
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
local function toggle_preview ()
  local MiniFiles = require("mini.files")
  MiniFiles.config.windows.preview = not MiniFiles.config.windows.preview
  MiniFiles.refresh({ windows = {
    preview = MiniFiles.config.windows.preview,
    width_preview = require("utils.system").distro == "archlinux" and 80 or 120,
  } })
end

-- Filter for hiding dot files
M.filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

-- Setup keymaps for MiniFiles buffer
M.setup_keymaps = function(buf_id)
  -- Navigation and utility
  vim.keymap.set("n", "+", set_cwd, { buffer = buf_id, desc = "Set cwd" })
  vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle dotfiles" })
  vim.keymap.set("n", "gX", ui_open, { buffer = buf_id, desc = "OS open" })
  vim.keymap.set("n", "<leader>cc", yank_path, { buffer = buf_id, desc = "Copy absolute path" })
  vim.keymap.set("n", "<leader>cd", yank_dir, { buffer = buf_id, desc = "Copy directory path" })
  vim.keymap.set("n", "<leader>cf", yank_fname, { buffer = buf_id, desc = "Copy file name" })
  vim.keymap.set("n", "<leader>cn", yank_fname_no_ext, { buffer = buf_id, desc = "Copy file name without extension" })
  vim.keymap.set("n", "<leader>cr", yank_relpath, { buffer = buf_id, desc = "Copy relative path" })

  map_split(buf_id, "_", "belowright vertical")
  map_split(buf_id, "<C-s>", "belowright horizontal")
  map_split(buf_id, "<C-t>", "tab")

  vim.keymap.set("n", "<C-p>", toggle_preview, { buffer = buf_id, desc = "Toggle preview" })
end

return M
