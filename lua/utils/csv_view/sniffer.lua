local M = {}

-----------------------------------------------------------------------------
-- 单行字段计数
-----------------------------------------------------------------------------
local function count_fields_in_line(line, delim, quote_char)
  local count = 0
  local in_quote = false
  local len = #line
  local delim_byte = delim:byte()
  local quote_byte = quote_char:byte()
  if len == 0 then return 0 end
  for i = 1, len do
    local b = line:byte(i)
    if b == quote_byte then
      in_quote = not in_quote
    elseif not in_quote and b == delim_byte then
      count = count + 1
    end
  end
  return count + 1
end

--- 采样打分，选出最佳分隔符
local function detect_delimiter(bufnr, quote_char, candidates)
  local n_samples = 10
  local total = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(n_samples, total), true)
  if #lines == 0 then return "," end

  local best_delim, best_score = ",", -1
  for _, delim in ipairs(candidates) do
    local min_c, max_c = math.huge, 0
    local valid = 0
    for _, line in ipairs(lines) do
      if #line > 0 then
        local n = count_fields_in_line(line, delim, quote_char)
        valid = valid + 1
        if n < min_c then min_c = n end
        if n > max_c then max_c = n end
      end
    end
    if valid > 0 and min_c >= 2 then
      local score = min_c * 10 - (max_c - min_c)
      if score > best_score then
        best_score = score
        best_delim = delim
      end
    end
  end
  return best_delim
end

--- 按优先级解析分隔符：filetype 命中 → 直接返回，否则自动检测
function M.resolve_delimiter(bufnr, config)
  local ft = vim.bo[bufnr].filetype
  local ft_map = config.parser.delimiter.ft
  if ft_map[ft] then
    return ft_map[ft], false
  end
  local quote_char = config.parser.quote_char
  local delim = detect_delimiter(bufnr, quote_char, config.parser.delimiter.fallbacks)
  return delim, true
end

return M
