local state_mod = require("utils.buffer_actions.state")

local M = {}

---Toggle pin on the current buffer.
function M.toggle_pin()
  local bufnr = vim.api.nvim_get_current_buf()
  if state_mod.state.pinned[bufnr] then
    state_mod.state.pinned[bufnr] = nil
    vim.notify("Unpinned: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
  else
    state_mod.state.pinned[bufnr] = true
    vim.notify("Pinned: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
  end
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
end

---Whether a buffer is pinned.
---@param bufnr number
---@return boolean
function M.is_pinned(bufnr)
  return state_mod.state.pinned[bufnr] == true
end

return M
