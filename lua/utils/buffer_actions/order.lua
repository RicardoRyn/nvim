local state_mod = require("utils.buffer_actions.state")
local utils = require("utils.buffer_actions.utils")

local M = {}

local function reconcile()
  -- fileter out invalid or unlisted buffers
  state_mod.state.buffer_order = vim.tbl_filter(function(bufnr)
    return vim.fn.buflisted(bufnr) == 1
  end, state_mod.state.buffer_order)
end

function M.save_buffer_order()
  local names = {}
  for _, bufnr in ipairs(state_mod.state.buffer_order) do
    local name = utils.buf_to_name(bufnr)
    table.insert(names, name)
  end
  vim.g.BufferOrder = vim.json.encode(names)
end

---@param bufnr number
function M.add_buffer_to_buffer_order(bufnr)
  if vim.fn.buflisted(bufnr) == 0 then
    return
  end
  for _, b in ipairs(state_mod.state.buffer_order) do
    if b == bufnr then
      return
    end
  end
  state_mod.state.buffer_order[#state_mod.state.buffer_order + 1] = bufnr

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

---@param bufnr number
function M.remove_buffer_from_buffer_order(bufnr)
  for i, b in ipairs(state_mod.state.buffer_order) do
    if b == bufnr then
      table.remove(state_mod.state.buffer_order, i)

      vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
      M.save_buffer_order()
      return
    end
  end
end

---Move the buffer to the left or right in the buffer order.
---@param direction number  1: right, -1: left
function M.move(direction)
  local current_bufnr = vim.api.nvim_get_current_buf()
  local index
  for i, bufnr in ipairs(state_mod.state.buffer_order) do
    if bufnr == current_bufnr then
      index = i
      break
    end
  end
  if not index then
    return
  end

  local next_index = index + direction
  if next_index < 1 or next_index > #state_mod.state.buffer_order then
    return
  else
    state_mod.state.buffer_order[index], state_mod.state.buffer_order[next_index] =
      state_mod.state.buffer_order[next_index], state_mod.state.buffer_order[index]
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "BufferOrderChanged", modeline = false })
  M.save_buffer_order()
end

---Cycle to the next/prev buffer in the given direction.
---@param direction number  1: right, -1: left
function M.cycle(direction)
  local current_buf = vim.api.nvim_get_current_buf()
  local index
  for i, buf in ipairs(state_mod.state.buffer_order) do
    if buf == current_buf then
      index = i
      break
    end
  end
  local next_index = index + direction
  if next_index < 1 then
    vim.cmd("buffer " .. state_mod.state.buffer_order[#state_mod.state.buffer_order])
  elseif next_index > #state_mod.state.buffer_order then
    vim.cmd("buffer " .. state_mod.state.buffer_order[1])
  else
    vim.cmd("buffer " .. state_mod.state.buffer_order[next_index])
  end
end

---Get the current buffer order.
function M.get_buffer_order()
  return state_mod.state.buffer_order
end

function M.init()
  local raw = vim.g.BufferOrder
  if not raw then
    -- 1. generate buffer_order by session file
    local session_file = utils.get_session_file()
    if session_file then
      for line in io.lines(session_file) do
        if line:match("^badd") then
          local name = vim.fn.fnamemodify(vim.fn.expand(line:match("%S+$")), ":p")
          local bufnr = vim.fn.bufnr(name)
          if bufnr ~= -1 then
            table.insert(state_mod.state.buffer_order, bufnr)
          end
        end
      end
    end
  else
    -- 2. generate buffer order by g:BufferOrder
    local names = vim.json.decode(raw)
    for _, name in ipairs(names) do
      local bufnr = vim.fn.bufnr(name)
      if bufnr ~= -1 then
        table.insert(state_mod.state.buffer_order, bufnr)
      end
    end
  end

  reconcile()
end

return M
