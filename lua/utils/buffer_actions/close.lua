local state_mod = require("utils.buffer_actions.state")
local order = require("utils.buffer_actions.order")
local utils = require("utils.buffer_actions.utils")
local pin = require("utils.buffer_actions.pin")

local M = {}

local PICK_ALPHABET = "asdfghjklqwertyuiopzxcvbnm1234567890"

local function assign_pick_letters()
  state_mod.pick_labels = {}
  local used = {}

  local cur_tab = vim.api.nvim_get_current_tabpage()
  local list = state_mod.tab_buffers[cur_tab] or {}
  for _, bufnr in ipairs(list) do
    local name = utils.buf_to_name(bufnr)
    local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or ""
    local first_char = filename:sub(1, 1):lower()

    local label = nil

    if first_char ~= "" and not used[first_char] and PICK_ALPHABET:find(first_char, 1, true) then
      -- if the first char is not uesd and belong to PICK_ALPHABET
      label = first_char
    else
      -- if not, find the first unused char in PICK_ALPHABET
      for c in PICK_ALPHABET:gmatch(".") do
        if not used[c] then
          label = c
          break
        end
      end
    end

    if label then
      state_mod.pick_labels[bufnr] = label
      used[label] = true
    end
  end
end

---Switch every window inside `tab` that is showing `bufnr` to a tab-local
---replacement (or an idle scratch buffer if the tab has no other buffers).
---Does NOT change state or trigger BufDelete.
---@param bufnr number
---@param tab number tabpage handle
local function replace_windows_in_tab(bufnr, tab)
  for _, win in ipairs(vim.fn.win_findbuf(bufnr) or {}) do
    local ok, win_tab = pcall(vim.api.nvim_win_get_tabpage, win)
    if ok and win_tab == tab then
      local repl = order.pick_close_replacement(bufnr)
      pcall(vim.api.nvim_win_set_buf, win, repl)
    end
  end
end

---Detach `bufnr` from `tab`: remove it from that tab's buffer list and switch
---any window of that tab showing it to a tab-local replacement.
---Does NOT call bdelete/bwipeout, does NOT touch other tabs' lists, does NOT
---change vim.bo[bufnr].buflisted. The buffer stays alive in the global buffer
---list and remains tracked by any other tab that has it.
---Refuses if the buffer has unsaved changes.
---@param bufnr number
---@param tab number|nil defaults to current tabpage
---@return boolean
local function detach(bufnr, tab)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  tab = tab or vim.api.nvim_get_current_tabpage()
  if not vim.api.nvim_tabpage_is_valid(tab) then
    return false
  end
  if vim.bo[bufnr].modified then
    vim.notify("Cannot detach: buffer has unsaved changes", vim.log.levels.WARN)
    return false
  end

  local tab_list = state_mod.tab_buffers[tab] or {}
  local found_in_tab = false
  for i, b in ipairs(tab_list) do
    if b == bufnr then
      table.remove(tab_list, i)
      found_in_tab = true
      break
    end
  end

  if not found_in_tab then
    return false
  end

  replace_windows_in_tab(bufnr, tab)

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  order.save_buffer_order()
  return true
end

---Close all buffers to the left or right of the current buffer in the buffer order.
---@alias Direction "'left'" | "'right'"
---@param direction Direction
function M.close_in_direction(direction)
  local current_buf = vim.api.nvim_get_current_buf()

  local cur_tab = vim.api.nvim_get_current_tabpage()
  local buffer_order = state_mod.tab_buffers[cur_tab] or {}

  local index
  for i, buf in ipairs(buffer_order) do
    if buf == current_buf then
      index = i
      break
    end
  end
  if not index then
    return
  end

  local to_close = {}
  if direction == "left" then
    for i = 1, index - 1 do
      to_close[#to_close + 1] = buffer_order[i]
    end
  else
    for i = index + 1, #buffer_order do
      to_close[#to_close + 1] = buffer_order[i]
    end
  end

  for _, buf in ipairs(to_close) do
    if not pin.is_pinned(buf) then
      M.close(buf)
    end
  end
end

---Pick a buffer to close.
function M.pick_close()
  if state_mod.is_picking then
    return
  end

  assign_pick_letters()
  state_mod.is_picking = true
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })

  -- wait for user to input char
  local ok, char_ascii = pcall(vim.fn.getchar)

  if ok and char_ascii then
    local input_char = vim.fn.nr2char(char_ascii):lower()
    for bufnr, label in pairs(state_mod.pick_labels) do
      if label == input_char then
        M.close(bufnr)
        break
      end
    end
  end

  state_mod.is_picking = false
  state_mod.pick_labels = {}
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
end

---Unified close entry point. For shared buffers: detach from current tab only
---(buffer stays alive for other tabs). For exclusive buffers: replace windows in
---the current tab, then globally delete via Snacks.bufdelete (BufDelete autocmd
---cleans up all tabs' state).
---@param bufnr number
function M.close(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  local cur_tab = vim.api.nvim_get_current_tabpage()

  if order.is_shared(bufnr) then
    detach(bufnr, cur_tab)
    return
  end

  -- FIX: 删除完当前buffer，就会跳到第一个buffer，而不是前一个buffer
  replace_windows_in_tab(bufnr, cur_tab)

  local ok_snacks, _ = pcall(Snacks.bufdelete, bufnr)
  if ok_snacks then
    return
  end

  local ok_mini, _ = pcall(require("mini.bufremove").delete, bufnr)
  if ok_mini then
    return
  end

  pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
end

return M
