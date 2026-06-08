---@class util.special_mode
local M = {}

---Returns true when nvim was launched as a diff/merge tool (hunk.nvim, jj, etc.).
---Check vim.v.argv for known -c command patterns.
---@return boolean
function M.is_active()
  for _, arg in ipairs(vim.v.argv) do
    if arg:match("DiffEditor") or arg:match("MergeEditor") or arg:match("wincmd J") then
      return true
    end
  end
  return false
end

return M
