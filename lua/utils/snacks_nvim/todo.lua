local M = {}

local default_kws = { "FIX", "TODO", "WARN", "HACK", "PERF", "TEST", "TOG", "SETTING", "NOTE" }

local function kw_to_hl(kw)
  return "MiniHipatterns" .. kw:sub(1, 1) .. kw:sub(2):lower()
end

local function find_keyword(line)
  if not line or line == "" then
    return nil
  end
  local upper = line:upper()
  local first_kw, first_pos = nil, math.huge
  for _, kw in ipairs(default_kws) do
    local s = upper:find("%f[%w]" .. kw .. ":")
    if s and s < first_pos then
      first_pos = s
      first_kw = kw
    end
  end
  return first_kw
end

local function build_regex(kws)
  return "\\b(" .. table.concat(kws, "|") .. "):"
end

local function format(item, picker)
  local ret = {}
  local line = item.line
  if not line and item.resolve then
    item.resolve()
    line = item.line
  end
  local kw = find_keyword(line or item.text)
  if kw then
    local hl = kw_to_hl(kw)
    local pad = 7 - vim.fn.strchars(kw)
    ret[#ret + 1] = { kw .. (pad > 0 and string.rep(" ", pad) or ""), hl }
    ret[#ret + 1] = { " " }
  end
  return Snacks.picker.highlight.extend(ret, Snacks.picker.format.file(item, picker))
end

function M.source(kws)
  return {
    finder = "grep",
    search = build_regex(kws or default_kws),
    live = false,
    supports_live = true,
    format = format,
  }
end

return M
