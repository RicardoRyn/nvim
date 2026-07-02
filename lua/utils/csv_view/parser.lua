local M = {}

local function is_number_str(str)
  local trimmed = str:match("^%s*(.-)%s*$")
  if trimmed == "" then return false end
  return tonumber(trimmed) ~= nil
end

local function buf_get_line(bufnr, lnum)
  local count = vim.api.nvim_buf_line_count(bufnr)
  if lnum < 1 or lnum > count then return nil end
  return vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1]
end

local function find_closing_quote(line, start_pos, quote_byte)
  local len = #line
  local pos = start_pos
  while pos <= len do
    if line:byte(pos) == quote_byte then
      if pos + 1 <= len and line:byte(pos + 1) == quote_byte then
        pos = pos + 2
      else
        return pos
      end
    else
      pos = pos + 1
    end
  end
  return nil
end

---@class CsvField
---@field offset integer
---@field len integer
---@field text string
---@field display_width integer
---@field is_number boolean

function M.parse_line(line, delim, quote_char, continuation)
  if not line or #line == 0 then return {}, false end

  local delim_byte = delim:byte()
  local quote_byte = quote_char:byte()
  local fields = {}
  local pos = 1
  local field_start = 1
  local len = #line
  local has_unclosed_quote = false

  if continuation then
    local close_pos = find_closing_quote(line, 1, quote_byte)
    if close_pos then
      pos = close_pos + 1
    else
      has_unclosed_quote = true
      local text = line:sub(field_start)
      local field = { offset = field_start - 1, len = len, text = text }
      field.display_width = vim.fn.strdisplaywidth(field.text)
      field.is_number = is_number_str(field.text)
      table.insert(fields, field)
      return fields, has_unclosed_quote
    end
  end

  while pos <= len do
    local b = line:byte(pos)
    if b == quote_byte then
      local close_pos = find_closing_quote(line, pos + 1, quote_byte)
      if close_pos then
        pos = close_pos + 1
      else
        has_unclosed_quote = true
        break
      end
    elseif b == delim_byte then
      local text = line:sub(field_start, pos - 1)
      table.insert(fields, { offset = field_start - 1, len = pos - field_start, text = text })
      pos = pos + 1
      field_start = pos
    else
      pos = pos + 1
    end
  end

  local text = line:sub(field_start)
  table.insert(fields, { offset = field_start - 1, len = #line - field_start + 1, text = text })

  for _, f in ipairs(fields) do
    f.display_width = vim.fn.strdisplaywidth(f.text)
    f.is_number = is_number_str(f.text)
  end

  return fields, has_unclosed_quote
end

local function find_multiline_end(bufnr, start_lnum, quote_char)
  local quote_byte = quote_char:byte()
  local total = vim.api.nvim_buf_line_count(bufnr)
  local max_lookahead = 50
  local lnum = start_lnum + 1
  while lnum <= total and lnum <= start_lnum + max_lookahead do
    local line = buf_get_line(bufnr, lnum)
    if not line then return lnum end
    if find_closing_quote(line, 1, quote_byte) then return lnum end
    lnum = lnum + 1
  end
  return lnum - 1
end

function M.compute_metrics(bufnr, delim, quote_char)
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local rows = {}
  local column_widths = {}

  local lnum = 1
  while lnum <= total_lines do
    local line = buf_get_line(bufnr, lnum)
    if not line then
      lnum = lnum + 1
      goto continue
    end

    local fields, has_unclosed_quote = M.parse_line(line, delim, quote_char, false)
    rows[lnum] = { fields = fields, continuation = false }

    if not has_unclosed_quote then
      for col_idx, f in ipairs(fields) do
        if not column_widths[col_idx] or f.display_width > column_widths[col_idx] then
          column_widths[col_idx] = f.display_width
        end
      end
      lnum = lnum + 1
    else
      for col_idx, f in ipairs(fields) do
        if not column_widths[col_idx] or f.display_width > column_widths[col_idx] then
          column_widths[col_idx] = f.display_width
        end
      end

      local end_lnum = find_multiline_end(bufnr, lnum, quote_char)
      local parent_col = #fields
      local skipped = #fields - 1

      for cl = lnum + 1, end_lnum do
        local cline = buf_get_line(bufnr, cl)
        local cfields = {}
        if cline then cfields, _ = M.parse_line(cline, delim, quote_char, true) end
        rows[cl] = {
          fields = cfields,
          continuation = true,
          parent_lnum = lnum,
          skipped_ncol = skipped,
        }
        for fidx, cf in ipairs(cfields) do
          local col = parent_col + fidx - 1
          if not column_widths[col] or cf.display_width > column_widths[col] then
            column_widths[col] = cf.display_width
          end
        end
        skipped = skipped + math.max(0, #cfields - 1)
      end
      lnum = end_lnum + 1
    end

    ::continue::
  end

  return { rows = rows, column_widths = column_widths }
end

return M
