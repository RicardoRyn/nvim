local M = {}

local function find_field_index(fields, col)
  for i = #fields, 1, -1 do
    if col >= fields[i].offset then return i end
  end
  return 1
end

function M.goto_next_field()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = require("utils.csv_view").get_state(bufnr)
  if not state or not state.enabled or not state.metrics then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = state.metrics.rows[cursor[1]]
  if not row or row.continuation or #row.fields == 0 then return end

  local idx = find_field_index(row.fields, cursor[2])
  if idx < #row.fields then
    vim.api.nvim_win_set_cursor(0, { cursor[1], row.fields[idx + 1].offset })
  end
end

function M.goto_prev_field()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = require("utils.csv_view").get_state(bufnr)
  if not state or not state.enabled or not state.metrics then return end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = state.metrics.rows[cursor[1]]
  if not row or row.continuation or #row.fields == 0 then return end

  local idx = find_field_index(row.fields, cursor[2])
  if idx > 1 then
    vim.api.nvim_win_set_cursor(0, { cursor[1], row.fields[idx - 1].offset })
  end
end

return M
