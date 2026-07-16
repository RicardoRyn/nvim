local M = {}

-- Avoid jj process contention when Hunk.nvim or merge-tools.vimdiff triggers diff-related modes.
local special_mode = require("utils.special_mode")

if special_mode.is_active() then
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

local jj_args = {
  "jj",
  "log",
  "--revisions",
  "@",
  "--no-graph",
  "--limit",
  "1",
  "--template",
  [[
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
]],
}

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
local debounce_timer = nil
local last_jj_root = nil

local root_cache = {}

local function get_jj_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = vim.uv.cwd()
  end
  local dir = vim.fs.dirname(path)
  if root_cache[dir] == nil then
    root_cache[dir] = vim.fs.root(path, ".jj") or false
  end
  return root_cache[dir] or nil
end

local function notify_status_updated()
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "JJStatusUpdated" })
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
    pcall(running_job_id.kill, running_job_id)
    running_job_id = nil
  end
end

local function update_status(force)
  if is_exiting then
    return
  end

  local jj_root = get_jj_root()

  if not jj_root then
    stop_running_job()
    if cached_status ~= "" then
      cached_status = ""
      last_jj_root = nil
      notify_status_updated()
    end
    return
  end

  if not force and jj_root == last_jj_root then
    return
  end
  last_jj_root = jj_root

  status_request_id = status_request_id + 1
  local request_id = status_request_id

  stop_running_job()

  running_job_id = vim.system(jj_args, { cwd = jj_root, text = true }, function(result)
    if request_id ~= status_request_id then
      return
    end

    running_job_id = nil
    if result.code == 0 then
      cached_status = " " .. vim.trim(result.stdout)
    else
      cached_status = ""
    end
    notify_status_updated()
  end)
end

local function debounced_update(force)
  if debounce_timer then
    debounce_timer:stop()
  end
  debounce_timer = vim.defer_fn(function()
    update_status(force)
  end, 100)
end

local augroup = vim.api.nvim_create_augroup("SetupJJLog", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  callback = function()
    debounced_update(true)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    debounced_update(false)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = function()
    is_exiting = true
    stop_running_job()
  end,
})

vim.schedule(function()
  update_status(true)
end)

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
