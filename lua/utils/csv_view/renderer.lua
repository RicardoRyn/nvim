local M = {}

local NS = vim.api.nvim_create_namespace("csvview")

function M.define_highlights()
  for i = 0, 9 do
    vim.api.nvim_set_hl(0, "CsvViewCol" .. i, { link = "csvCol" .. i })
  end
  vim.api.nvim_set_hl(0, "CsvViewDelimiter", { link = "Comment" })
  vim.api.nvim_set_hl(0, "CsvViewHeaderLine", { bold = true, underline = true, default = true })
  vim.api.nvim_set_hl(0, "CsvViewStickyHeaderSeparator", { link = "Delimiter", default = true })
end

function M.add_extmark(state, bufnr, line, col, opts)
  local id = vim.api.nvim_buf_set_extmark(bufnr, NS, line - 1, col, opts)
  if not state.extmarks[line] then state.extmarks[line] = {} end
  table.insert(state.extmarks[line], id)
  state.rendered[line] = true
  return id
end

function M.clear_rendering(bufnr, state)
  vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
  state.extmarks = {}
  state.rendered = {}
end

local function get_align_direction(field)
  return field.is_number and "right" or "left"
end

function M.render_field(state, bufnr, lnum, col_idx, field, fields, column_widths, config, field_idx)
  field_idx = field_idx or col_idx
  local col_width = column_widths[col_idx]
  if not col_width then return end
  col_width = math.max(col_width, 1)

  local align_dir = get_align_direction(field)
  local align_padding = col_width - field.display_width
  local before_padding = config.view.left_spacing
  local after_padding = config.view.right_spacing

  if field.offset == 0 then before_padding = 0 end

  if align_dir == "right" then
    before_padding = before_padding + align_padding
  else
    after_padding = after_padding + align_padding
  end

  if before_padding > 0 then
    M.add_extmark(state, bufnr, lnum, field.offset, {
      virt_text = { { string.rep(" ", before_padding) } },
      virt_text_pos = "inline",
      right_gravity = false,
    })
  end

  if after_padding > 0 then
    M.add_extmark(state, bufnr, lnum, field.offset + field.len, {
      virt_text = { { string.rep(" ", after_padding) } },
      virt_text_pos = "inline",
      right_gravity = true,
    })
  end

  local hl_name = "CsvViewCol" .. (col_idx - 1) % 9
  M.add_extmark(state, bufnr, lnum, field.offset, {
    hl_group = hl_name,
    end_col = field.offset + field.len,
  })

  if config.view.display_mode == "border" and field_idx < #fields then
    local next_field = fields[field_idx + 1]
    M.add_extmark(state, bufnr, lnum, field.offset + field.len, {
      hl_group = "CsvViewDelimiter",
      end_col = next_field.offset,
      conceal = config.view.border_char,
    })
  end
end

function M.render_line(state, bufnr, lnum, metrics, config)
  if state.rendered[lnum] then return end

  local row = metrics.rows[lnum]
  if not row then
    state.rendered[lnum] = true
    return
  end

  if row.continuation then
    local skipped = row.skipped_ncol or 0
    if skipped > 0 then
      local pad = 0
      for i = 1, skipped do
        local w = metrics.column_widths[i] or 1
        w = math.max(w, 1)
        if i == 1 then
          pad = pad + w + config.view.right_spacing + 1
        else
          pad = pad + config.view.left_spacing + w + config.view.right_spacing + 1
        end
      end
      pad = pad + config.view.left_spacing
      if pad > 0 then
        M.add_extmark(state, bufnr, lnum, 0, {
          virt_text = { { string.rep(" ", pad) } },
          virt_text_pos = "inline",
          right_gravity = false,
        })
      end
    end
    local fields = row.fields
    for field_idx, field in ipairs(fields) do
      M.render_field(state, bufnr, lnum, skipped + field_idx, field, fields, metrics.column_widths, config, field_idx)
    end
    state.rendered[lnum] = true
    return
  end

  local fields = row.fields
  if #fields == 0 then
    state.rendered[lnum] = true
    return
  end

  for col_idx, field in ipairs(fields) do
    M.render_field(state, bufnr, lnum, col_idx, field, fields, metrics.column_widths, config)
  end

  if lnum == 1 then
    M.add_extmark(state, bufnr, lnum, 0, { line_hl_group = "CsvViewHeaderLine" })
  end
end

function M.render_visible(state, bufnr, metrics, config)
  local winids = vim.fn.win_findbuf(bufnr)
  if #winids == 0 then return end

  local winid = winids[1]
  local top = vim.fn.line("w0", winid)
  local bot = vim.fn.line("w$", winid)

  for lnum = top, bot do
    M.render_line(state, bufnr, lnum, metrics, config)
  end
end

return M
