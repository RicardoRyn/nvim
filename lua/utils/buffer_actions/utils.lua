local M = {}

---@return string|nil
function M.get_session_file()
  local session_dir = vim.fs.joinpath(vim.fn.stdpath("state"), "sessions")
  local fname = vim.fn.substitute(vim.fn.getcwd(), "[/\\\\:]", "%%", "g") .. ".vim"
  local path = vim.fs.joinpath(session_dir, fname)

  if vim.fn.filereadable(path) == 1 then
    return path
  else
    return nil
  end
end

---@param bufnr number
---@return string|nil
function M.buf_to_name(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end
  return vim.fn.fnamemodify(name, ":p")
end

---@param bufnr number
function M.close_buffer(bufnr)
  local ok_snacks, snacks_bufdelete = pcall(Snacks, "bufdelete")
  if ok_snacks then
    snacks_bufdelete(bufnr)
  else
    pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
  end
end

return M
