if vim.g.vscode then return end

local special_mode = require("utils.special_mode")

local session_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")
vim.fn.mkdir(session_dir, "p")
local fname = vim.fn.substitute(vim.fn.getcwd(), "[/\\\\:]", "%%", "g") .. ".vim"
local session_file = vim.fs.joinpath(session_dir, fname)

local function cleanup_jj_temp_files()
  -- remove file from args
  local argv = vim.fn.argv()
  for i = #argv, 1, -1 do
    vim.cmd("argdelete " .. argv[i])
  end

  -- delete any .jjdescription buffers that might be open
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("editor.-%.jjdescription$") then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end
end

local augroup = vim.api.nvim_create_augroup("SetupSession", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  nested = true,
  callback = function()
    if special_mode.is_active() then
      return
    end
    if vim.fn.argc() == 0 and vim.fn.filereadable(session_file) == 1 then
      vim.cmd("source " .. vim.fn.fnameescape(session_file))
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function()
    if special_mode.is_active() then
      return
    end
    cleanup_jj_temp_files() -- remove .jjdescription files from args before saving session
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_file))
  end,
})
