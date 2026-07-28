local special_mode = require("utils.special_mode")

local function augroup(name)
  return vim.api.nvim_create_augroup("Init" .. name, { clear = true })
end

-- Check if the current buffer is outside the cwd
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("CheckWorkspaceJump"),
  callback = function(args)
    local buf = args.buf
    -- 1. Ignore the special buffers
    if vim.bo[buf].buftype ~= "" then
      return
    end
    -- 2. Ignore special mode
    if special_mode.is_active() then
      return
    end
    -- 3. Ignore floating windows
    local win = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win)
    if win_config.relative ~= "" then
      return
    end
    -- 4. Only warn once per buffer
    if vim.b[buf].out_of_workspace_warned then
      return
    end
    local filepath = vim.api.nvim_buf_get_name(buf)
    if filepath == "" then
      return
    end

    local cwd = vim.fs.normalize(vim.fn.getcwd())
    filepath = vim.fs.normalize(filepath)
    if cwd:sub(-1) ~= "/" then
      cwd = cwd .. "/"
    end
    if not vim.startswith(filepath, cwd) then
      vim.notify("Jump to:\n" .. filepath, vim.log.levels.WARN, { title = "Jump out of workspace" })
      vim.b[buf].out_of_workspace_warned = true
    end
  end,
})

-- Disable automatic comment insertion when using `o` and `O`
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("DisableOComment"),
  pattern = { "lua", "python", "sh", "rust" },
  callback = function()
    vim.opt.formatoptions:remove({ "o" })
  end,
})

-- Disables the conceal feature in JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("JsonConceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Create the dir before saving the file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("AutoCreateDir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Quit some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("CloseWithQ"),
  pattern = {
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- NOTE: Handled by mini `require('mini.misc').setup_restore_cursor()`
-- -- Restore the last cursor position when reopening a file
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   group = augroup("LastLoc"),
--   callback = function(event)
--     local exclude = { "gitcommit" }
--     local buf = event.buf
--     if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].ricardo_last_loc then
--       return
--     end
--     vim.b[buf].ricardo_last_loc = true
--     local mark = vim.api.nvim_buf_get_mark(buf, '"')
--     local lcount = vim.api.nvim_buf_line_count(buf)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })
