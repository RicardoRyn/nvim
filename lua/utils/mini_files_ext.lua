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

return M
