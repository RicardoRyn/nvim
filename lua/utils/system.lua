local M = {}

M.is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
M.is_mac = vim.fn.has("macunix") == 1
M.is_linux = vim.fn.has("linux") == 1

-- External shell to use for system() calls, per OS
if M.is_win then
  M.shell = "nu"
elseif M.is_mac then
  M.shell = "bash"
else -- linux
  M.shell = "bash"
end

-- Linux distribution (used to distinguish ubuntu / arch / etc.)
M.distro = "unknown"
if M.is_linux then
  local f = io.open("/etc/os-release", "r")
  if f then
    local content = f:read("*all")
    f:close()
    local id = content:match("^ID%s*=%s*[\"']?([^\"'\n]+)[\"']?") or content:match("\nID%s*=%s*[\"']?([^\"'\n]+)[\"']?")
    -- Arch Linux reports `ID=arch` in /etc/os-release, normalize it.
    M.distro = id == "arch" and "archlinux" or (id or "unknown")
  end
end

return M
