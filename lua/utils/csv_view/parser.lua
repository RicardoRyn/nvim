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

function M.compute_metrics(bufnr, delim, quote_char, limit)
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  if limit then total_lines = math.min(total_lines, limit) end
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

--- 大文件模式：只解析前 sample_lines 行估算列宽，其余行惰性解析
function M.compute_metrics_sampled(bufnr, delim, quote_char, sample_lines)
  return M.compute_metrics(bufnr, delim, quote_char, sample_lines)
end

local function update_width(column_widths, col, width)
  if not column_widths[col] or width > column_widths[col] then
    column_widths[col] = width
    return true
  end
  return false
end

--- 最后一个引号之后是否还有分隔符。
--- 开启跨行字段的引号位于行尾；闭合引号后通常还有后续字段，
--- 用此区分"父行"与"本身是续行"的候选
local function delim_after_last_quote(line, delim, quote_char)
  local qpos = nil
  local pos = 1
  local quote_byte = quote_char:byte()
  while true do
    local s = line:find(quote_char, pos, true)
    if not s then break end
    qpos = s
    pos = s + 1
  end
  if not qpos then return false end
  return line:find(delim, qpos + 1, true) ~= nil
end

--- 大文件模式：按需解析单行并写入缓存。
--- 跨行引号字段用有限向上回溯启发式判断续行，找不到则按普通行降级。
--- 返回 row, grew（grew 表示列宽被加宽，调用方需重渲染已渲染行）
function M.ensure_row(bufnr, metrics, lnum, delim, quote_char, max_lookbehind)
  local cached = metrics.rows[lnum]
  if cached then return cached, false end

  local line = buf_get_line(bufnr, lnum)
  if not line then
    local row = { fields = {}, continuation = false }
    metrics.rows[lnum] = row
    return row, false
  end

  local quote_byte = quote_char:byte()
  local parent = nil
  for j = lnum - 1, math.max(1, lnum - max_lookbehind), -1 do
    local jrow = metrics.rows[j]
    -- 已判定为续行的行不可能是父行
    if not (jrow and jrow.continuation) then
      local jline = buf_get_line(bufnr, j)
      if jline then
        local _, unclosed = M.parse_line(jline, delim, quote_char, false)
        -- 闭合引号后还有分隔符 → j 本身是续行，其引号被误读为开启引号
        if unclosed and not delim_after_last_quote(jline, delim, quote_char) then
          -- 向前验证：候选行的未闭合引号必须在到达 lnum 前保持未闭合
          local closed = false
          for k = j + 1, lnum - 1 do
            local kline = buf_get_line(bufnr, k)
            if kline and find_closing_quote(kline, 1, quote_byte) then
              closed = true
              break
            end
          end
          if not closed then
            parent = j
            break
          end
        end
      end
    end
  end

  local grew = false
  local widths = metrics.column_widths

  if not parent then
    local fields = M.parse_line(line, delim, quote_char, false)
    for col_idx, f in ipairs(fields) do
      grew = update_width(widths, col_idx, f.display_width) or grew
    end
    local row = { fields = fields, continuation = false }
    metrics.rows[lnum] = row
    return row, grew
  end

  local prow = metrics.rows[parent]
  local pfields
  if prow and not prow.continuation then
    pfields = prow.fields
  else
    pfields = M.parse_line(buf_get_line(bufnr, parent), delim, quote_char, false)
    metrics.rows[parent] = { fields = pfields, continuation = false }
    for col_idx, f in ipairs(pfields) do
      grew = update_width(widths, col_idx, f.display_width) or grew
    end
  end

  local parent_col = #pfields
  local skipped = parent_col - 1
  local row
  for cl = parent + 1, lnum do
    local existing = metrics.rows[cl]
    local cfields
    if existing and existing.continuation then
      cfields = existing.fields
    else
      local cline = buf_get_line(bufnr, cl)
      cfields = cline and M.parse_line(cline, delim, quote_char, true) or {}
    end
    local crow = {
      fields = cfields,
      continuation = true,
      parent_lnum = parent,
      skipped_ncol = skipped,
    }
    metrics.rows[cl] = crow
    for fidx, cf in ipairs(cfields) do
      grew = update_width(widths, parent_col + fidx - 1, cf.display_width) or grew
    end
    skipped = skipped + math.max(0, #cfields - 1)
    if cl == lnum then row = crow end
  end
  return row, grew
end

return M
