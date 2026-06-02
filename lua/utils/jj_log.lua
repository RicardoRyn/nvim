local M = {}

-- Avoid jj process contention when Hunk.nvim or merge-tools.vimdiff triggers diff-related modes.
local function is_special_mode()
  for _, arg in ipairs(vim.v.argv) do
    if arg:match("DiffEditor") or arg:match("wincmd J") then
      return true
    end
  end
  return false
end

if is_special_mode() then
  M.is_jj_repo = function()
    return false
  end
  M.get = function()
    return ""
  end
  M.get_color = function()
    return nil
  end
  return M
end

local jj_cmd = [[jj log --revisions @ --no-graph --color never --limit 1 --template '
  separate(" ",
    change_id.shortest(4),
    bookmarks,
    concat(
      if(conflict, "💥"),
      if(divergent, "🚧"),
      if(hidden, "👻"),
      if(immutable, "🔒"),
    ),
    if(
      empty,
      "󰱒",
      "󰏭"
    ),
    coalesce(
      truncate_end(29, description.first_line(), "…"),
      "󰄱 "
    )
  )
']]
local status_symbols = {
  conflicted = "💥",
  divergent = "🚧",
  immutable = "🔒",
  empty = "󰱒",
}
local cached_status = ""
local is_exiting = false
local running_job_id = nil
local status_request_id = 0

local function get_jj_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = (vim.uv or vim.loop).cwd()
  end
  return vim.fs.root(path, ".jj")
end

local function notify_status_updated()
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "JjStatusUpdated" })
  end)
end

local function fg_from_hl(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and hl.fg then
    return string.format("#%06x", hl.fg)
  end
  return fallback
end

local function stop_running_job()
  if running_job_id then
    vim.fn.jobstop(running_job_id)
    running_job_id = nil
  end
end

local function update_status()
  if is_exiting then
    return
  end

  status_request_id = status_request_id + 1
  local request_id = status_request_id
  local jj_root = get_jj_root()

  if not jj_root then
    -- 取消旧任务
    stop_running_job()

    if cached_status ~= "" then
      cached_status = ""
      notify_status_updated()
    end
    return
  end

  -- 取消旧任务
  stop_running_job()

  local output = {}

  running_job_id = vim.fn.jobstart(jj_cmd, {
    cwd = jj_root,
    stdout_buffered = true,

    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,

    on_exit = function(_, exit_code)
      -- 忽略旧回调
      if request_id ~= status_request_id then
        return
      end

      running_job_id = nil
      if exit_code == 0 then
        local result = table.concat(output, "")
        cached_status = " " .. vim.trim(result)
      else
        cached_status = ""
      end
      notify_status_updated()
    end,
  })
end

local augroup = vim.api.nvim_create_augroup("jj_log", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  group = augroup,
  callback = function()
    update_status()
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function()
    is_exiting = true
    stop_running_job()
  end,
})

vim.schedule(update_status)

M.is_jj_repo = function()
  return get_jj_root() ~= nil
end

M.get = function()
  return cached_status
end

M.get_color = function()
  if cached_status == "" then
    return nil
  end

  if
    cached_status:find(status_symbols.conflicted)
    or cached_status:find(status_symbols.divergent)
    or cached_status:find(status_symbols.immutable)
  then
    return { fg = fg_from_hl("DiagnosticError", "#ff0000"), gui = "bold" }
  elseif cached_status:find(status_symbols.empty) then
    return { fg = fg_from_hl("DiffAdded", "#00ff00"), gui = "bold" }
  else
    return { fg = fg_from_hl("DiagnosticWarn", "#ffff00"), gui = "bold" }
  end
end

return M
