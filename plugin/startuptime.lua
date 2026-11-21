--- 在.bashrc中用以下函数替换nvim命令：
---
--- function nvim() {
---   local log="${TMPDIR:-/tmp}nvim-startup-$$.log"
---   rm -f "$log"
---   NVIM_STARTUP_LOG="$log" command nvim --startuptime "$log" "$@"
---   local rc=$?
---   rm -f "$log"
---   return $rc
--- }
---
---
--- 对于windows的nushell：
---
--- export def --env nvim [...args: string] {
---     let log = ($env.TEMP? | default $env.TMP? | default "/tmp") + $"/nvim-startup-(random uuid).log"
---     with-env { NVIM_STARTUP_LOG: $log } {
---         ^nvim --startuptime $log ...$args
---     }
---     let rc = $env.LAST_EXIT_CODE
---     try {
---         rm -f $log
---     } catch {
---     }
---     if $rc != 0 {
---         error make { msg: $"nvim exited with code ($rc)" }
---     }
--- }

local function log_path()
  local a = vim.v.argv
  for i = 1, #a do
    if a[i] == "--startuptime" then
      return a[i + 1]
    end
    local eq = a[i]:match("^%-%-startuptime=(.+)$")
    if eq then
      return eq
    end
  end
  return vim.env.NVIM_STARTUP_LOG
end

local function read_total()
  local path = log_path()
  if not path then
    return nil, "本次不是用 --startuptime 启动的"
  end
  local f = io.open(path, "r")
  if not f then
    return nil, "读不到日志: " .. path
  end
  local total
  for line in f:lines() do -- 可能有多次启动，取最后一条
    if line:find("NVIM STARTED", 1, true) then
      total = tonumber(line:match("^%s*([%d%.]+)"))
    end
  end
  f:close()
  return total
end

vim.api.nvim_create_user_command("StartupTime", function()
  local ms, err = read_total()
  if ms then
    vim.notify(("%.1f ms"):format(ms), vim.log.levels.INFO, { title = "NVIM STARTED" })
  else
    vim.notify(err, vim.log.levels.WARN, { title = "startuptime" })
  end
end, { desc = "Startup Time" })

-- -- 如果想在启动时自动显示启动时间，可以取消下面的注释
-- vim.api.nvim_create_autocmd("VimEnter", {
--   once = true,
--   callback = function()
--     vim.defer_fn(function()
--       local ms = read_total()
--       if not ms then
--         return
--       end
--       vim.notify(("%.1f ms"):format(ms), vim.log.levels.INFO, { title = "NVIM STARTED" })
--     end, 0)
--   end,
-- })
