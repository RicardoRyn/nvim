local M = {}

M.is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_mac = vim.fn.has("macunix") == 1
M.is_linux = vim.fn.has("linux") == 1

M.distro = "unknown"
if M.is_linux then
  local f = io.open("/etc/os-release", "r")
  if f then
    local content = f:read("*all")
    f:close()
    local id = content:match("^ID%s*=%s*[\"']?([^\"'\n]+)[\"']?") or content:match("\nID%s*=%s*[\"']?([^\"'\n]+)[\"']?")
    M.distro = id or "unknown"
  end
end

return M
