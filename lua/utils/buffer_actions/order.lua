local state_mod = require("utils.buffer_actions.state")
local utils = require("utils.buffer_actions.utils")

local M = {}

local function current_tab()
  return vim.api.nvim_get_current_tabpage()
end

local function current_list()
  local tab = current_tab()
  if not state_mod.tab_buffers[tab] then
    state_mod.tab_buffers[tab] = {}
  end
  return state_mod.tab_buffers[tab]
end

local function is_listed(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) and vim.fn.buflisted(bufnr) == 1
end

local function filter_valid(list)
  return vim.tbl_filter(is_listed, list)
end

local function reconcile()
  for tab, list in pairs(state_mod.tab_buffers) do
    if vim.api.nvim_tabpage_is_valid(tab) then
      state_mod.tab_buffers[tab] = filter_valid(list)
    else
      state_mod.tab_buffers[tab] = nil
    end
  end
end

local function create_idle_buffer()
  return vim.api.nvim_create_buf(true, false)
end

---Pick a replacement buffer from the current tab's buffer list, excluding `exclude`.
---If none is available, returns a freshly-created idle empty buffer (`:enew` style:
---listed, modifiable, ordinary unnamed buffer — the user can press `i` to start typing).
---@param exclude number|nil
---@return number
function M.pick_tab_replacement(exclude)
  for _, bufnr in ipairs(current_list()) do
    if bufnr ~= exclude and is_listed(bufnr) then
      return bufnr
    end
  end
  return create_idle_buffer()
end

---Pick the buffer that should replace `exclude` when it is closed from the
---current tab. Prefers the buffer at index-1 (previous in order), then index+1,
---then a fresh idle buffer if the tab would otherwise be empty.
---@param exclude number
---@return number
function M.pick_close_replacement(exclude)
  local list = current_list()
  local index
  for i, b in ipairs(list) do
    if b == exclude then
      index = i
      break
    end
  end
  if not index then
    for _, b in ipairs(list) do
      if b ~= exclude and is_listed(b) then
        return b
      end
    end
    return create_idle_buffer()
  end
  local prev = list[index - 1]
  if prev and is_listed(prev) then
    return prev
  end
  local nxt = list[index + 1]
  if nxt and is_listed(nxt) then
    return nxt
  end
  return create_idle_buffer()
end


function M.save_buffer_order()
  local tabs = vim.api.nvim_list_tabpages()
  local tab_entries = {}

  for _, tab in ipairs(tabs) do
    local list = state_mod.tab_buffers[tab] or {}
    local names = {}
    for _, bufnr in ipairs(list) do
      local name = utils.buf_to_name(bufnr)
      if name then
        table.insert(names, name)
      end
    end
    table.insert(tab_entries, { bufs = names })
  end

  local data = { version = 2, tabs = tab_entries }
  vim.g.BufferOrder = vim.json.encode(data)
end

---@param tab number tabpage handle
---@param bufnr number
function M.add_buffer_to_tab(tab, bufnr)
  if not is_listed(bufnr) then
    return
  end
  if not vim.api.nvim_tabpage_is_valid(tab) then
    return
  end

  local list = state_mod.tab_buffers[tab]
  if not list then
    list = {}
    state_mod.tab_buffers[tab] = list
  end

  for _, b in ipairs(list) do
    if b == bufnr then
      return
    end
  end
  list[#list + 1] = bufnr

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

---Remove `bufnr` from every tab's buffer list.
---@param bufnr number
function M.remove_buffer(bufnr)
  for _, list in pairs(state_mod.tab_buffers) do
    for i, b in ipairs(list) do
      if b == bufnr then
        table.remove(list, i)
        break
      end
    end
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

---@param bufnr number
---@return boolean
function M.is_shared(bufnr)
  local count = 0
  for _, list in pairs(state_mod.tab_buffers) do
    for _, b in ipairs(list) do
      if b == bufnr then
        count = count + 1
        break
      end
    end
  end
  return count > 1
end

---Returns true iff `bufnr` is tracked by at least one tab OTHER than `exclude_tab`.
---Used by `on_tab_closed` to decide whether a buffer should be globally deleted
---when its closing tab goes away: keep the buffer if any other tab still uses it.
---@param bufnr number
---@param exclude_tab number
---@return boolean
function M.is_used_outside(bufnr, exclude_tab)
  for tab, list in pairs(state_mod.tab_buffers) do
    if tab ~= exclude_tab then
      for _, b in ipairs(list) do
        if b == bufnr then
          return true
        end
      end
    end
  end
  return false
end

---Move the current buffer to the left or right in the current tab's list.
---@param direction number  1: right, -1: left
function M.move(direction)
  local current_bufnr = vim.api.nvim_get_current_buf()
  local list = current_list()
  local index
  for i, bufnr in ipairs(list) do
    if bufnr == current_bufnr then
      index = i
      break
    end
  end
  if not index then
    return
  end

  local next_index = index + direction
  if next_index < 1 or next_index > #list then
    return
  else
    list[index], list[next_index] = list[next_index], list[index]
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

---Cycle to the next/prev buffer in the current tab's list.
---@param direction number  1: right, -1: left
function M.cycle(direction)
  local current_buf = vim.api.nvim_get_current_buf()
  local list = current_list()
  local index
  for i, buf in ipairs(list) do
    if buf == current_buf then
      index = i
      break
    end
  end
  if not index then
    return
  end
  local next_index = index + direction
  if next_index < 1 then
    vim.cmd("buffer " .. list[#list])
  elseif next_index > #list then
    vim.cmd("buffer " .. list[1])
  else
    vim.cmd("buffer " .. list[next_index])
  end
end

---Get a defensive copy of the current tab's buffer list.
---@return number[]
function M.get_buffer_order()
  return vim.deepcopy(current_list())
end

function M.init()
  local raw = vim.g.BufferOrder
  if raw then
    local ok, decoded = pcall(vim.json.decode, raw)
    if ok and decoded then
      if type(decoded) == "table" and decoded.version == 2 and decoded.tabs then
        local tabs = vim.api.nvim_list_tabpages()
        for i, tab in ipairs(tabs) do
          local entry = decoded.tabs[i]
          if entry and entry.bufs then
            local list = {}
            for _, name in ipairs(entry.bufs) do
              local bufnr = vim.fn.bufnr(name)
              if bufnr ~= -1 and is_listed(bufnr) then
                table.insert(list, bufnr)
              end
            end
            state_mod.tab_buffers[tab] = list
          end
        end
      else
        local tab = current_tab()
        local list = {}
        for _, name in ipairs(decoded) do
          local bufnr = vim.fn.bufnr(name)
          if bufnr ~= -1 and is_listed(bufnr) then
            table.insert(list, bufnr)
          end
        end
        state_mod.tab_buffers[tab] = list
      end
    end
  else
    local session_file = utils.get_session_file()
    if session_file then
      local tab = current_tab()
      local list = {}
      for line in io.lines(session_file) do
        if line:match("^badd") then
          local name = vim.fn.fnamemodify(vim.fn.expand(line:match("%S+$")), ":p")
          local bufnr = vim.fn.bufnr(name)
          if bufnr ~= -1 and is_listed(bufnr) then
            table.insert(list, bufnr)
          end
        end
      end
      state_mod.tab_buffers[tab] = list
    end
  end

  reconcile()
end

function M.restore()
  state_mod.tab_buffers = {}
  M.init()
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
end

function M.on_tab_enter()
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
end

function M.on_tab_new_entered()
  local tab = current_tab()
  local list = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local bufnr = vim.api.nvim_win_get_buf(win)
    if is_listed(bufnr) then
      local found = false
      for _, b in ipairs(list) do
        if b == bufnr then
          found = true
          break
        end
      end
      if not found then
        list[#list + 1] = bufnr
      end
    end
  end
  state_mod.tab_buffers[tab] = list
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

function M.on_tab_closed()
  local closing_tab = current_tab()
  local closing_bufs = vim.deepcopy(state_mod.tab_buffers[closing_tab] or {})

  vim.schedule(function()
    state_mod.tab_buffers[closing_tab] = nil

    for _, bufnr in ipairs(closing_bufs) do
      if is_listed(bufnr) and not M.is_used_outside(bufnr, closing_tab) then
        local ok_snacks, snacks_bufdelete = pcall(Snacks, "bufdelete")
        if ok_snacks then
          snacks_bufdelete(bufnr)
        else
          pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
        end
      end
    end
  end)
end

return M
