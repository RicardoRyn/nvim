local state_mod = require("utils.buffer_actions.state")
local utils = require("utils.buffer_actions.utils")

local M = {}

local PICK_ALPHABET = "asdfghjklqwertyuiopzxcvbnm1234567890"

local function assign_pick_letters()
  state_mod.state.pick_labels = {}
  local used = {}

  for _, bufnr in ipairs(state_mod.state.buffer_order) do
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
      state_mod.state.pick_labels[bufnr] = label
      used[label] = true
    end
  end
end

---Close all buffers to the left or right of the current buffer in the buffer order.
---@alias Direction "'left'" | "'right'"
---@param direction Direction
function M.close_in_direction(direction)
  local current_buf = vim.api.nvim_get_current_buf()

  local index
  for i, buf in ipairs(state_mod.state.buffer_order) do
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
      to_close[#to_close + 1] = state_mod.state.buffer_order[i]
    end
  else
    for i = index + 1, #state_mod.state.buffer_order do
      to_close[#to_close + 1] = state_mod.state.buffer_order[i]
    end
  end

  for _, buf in ipairs(to_close) do
    utils.close_buffer(buf)
  end
end

---Pick a buffer to close.
function M.pick_close()
  if state_mod.state.is_picking then
    return
  end

  assign_pick_letters()
  state_mod.state.is_picking = true
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })

  -- wait for user to input char
  local ok, char_ascii = pcall(vim.fn.getchar)

  if ok and char_ascii then
    local input_char = vim.fn.nr2char(char_ascii):lower()
    for bufnr, label in pairs(state_mod.state.pick_labels) do
      if label == input_char then
        utils.close_buffer(bufnr)
        break
      end
    end
  end

  state_mod.state.is_picking = false
  state_mod.state.pick_labels = {}
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
end

return M
