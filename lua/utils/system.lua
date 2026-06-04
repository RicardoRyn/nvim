local M = {}

local sysname = vim.uv.os_uname().sysname
if sysname == "Linux" then
  M.os = "Linux"
elseif sysname == "Darwin" then
  M.os = "Mac"
elseif sysname == "Windows_NT" then
  M.os = "Windows"
else
  M.os = "Other"
end

M.distro = "none"
if M.os == "Linux" then
  local f = io.open("/etc/os-release", "r")
  if f then
    local content = f:read("*all")
    f:close()
    M.distro = content:match("^ID=(%w+)") or content:match("\nID=(%w+)") or "other"
  end
end

M.is_win = M.os == "Windows"
M.is_mac = M.os == "Mac"
M.is_linux = M.os == "Linux"

return M
