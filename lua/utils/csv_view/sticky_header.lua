local M = {}

M._sticky_header_wins = {} ---@type table<integer, integer>  winid → header_winid

-----------------------------------------------------------------------------
-- 工具：获取窗口的 statuscolumn（含 fallback）
-----------------------------------------------------------------------------
---@param winid integer
---@return string
local function get_statuscolumn_or_default(winid)
  local stc = vim.api.nvim_get_option_value("statuscolumn", { win = winid, scope = "local" })
  if stc ~= "" then
    return stc
  end
  local num = vim.api.nvim_get_option_value("number", { win = winid, scope = "local" })
  return "%C%=%s%=%l" .. (num and " " or "")
end

--- 把 nvim_eval_statusline 的结果转为 statuscolumn 格式字符串
---@param eval_result table
---@return string
local function format_to_stc_string(eval_result)
  local text = eval_result.str or ""
  local highlights = eval_result.highlights
  if not highlights or #highlights == 0 then
    return text
  end
  local pieces = {}
  for i, hl in ipairs(highlights) do
    local start_index = hl.start
    local end_index = (i < #highlights) and highlights[i + 1].start or #text
    local segment = string.sub(text, start_index + 1, end_index)
    local groups = hl.groups or { hl.group }
    local group_name = #groups > 0 and groups[#groups] or "Normal"
    table.insert(pieces, "%#" .. group_name .. "#" .. segment .. "%*")
  end
  return table.concat(pieces)
end

--- 复制窗口选项
---@param names string[]
---@param source integer
---@param target integer
local function copy_win_options(names, source, target)
  for _, name in ipairs(names) do
    local value = vim.api.nvim_get_option_value(name, { win = source, scope = "local" })
    vim.api.nvim_set_option_value(name, value, { win = target, scope = "local" })
  end
end

--- 设置 sticky header 窗口选项
---@param header_winid integer
---@param winid integer
local function set_sticky_header_win_options(header_winid, winid)
  -- statuscolumn 回显原窗口的样式
  local stc = string.format("%%{%%v:lua.require('utils.csv_view.sticky_header').statuscolumn(%d)%%}", winid)
  vim.api.nvim_set_option_value("statuscolumn", stc, { win = header_winid, scope = "local" })
  vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal", { win = header_winid, scope = "local" })
  copy_win_options({ "relativenumber", "signcolumn", "foldcolumn", "numberwidth" }, winid, header_winid)
end

--- 获取分隔符 border
---@param separator string|false
---@return table|nil
local function get_sticky_header_border(separator)
  if not separator then
    return nil
  end
  local sep = { separator, "CsvViewStickyHeaderSeparator" }
  return { "", "", "", "", sep, sep, sep, "" }
end

--- 同步水平滚动
---@param winid integer
---@param header_winid integer
---@param header_lnum integer
local function sync_horizontal_scroll(winid, header_winid, header_lnum)
  local win_view = vim.api.nvim_win_call(winid, vim.fn.winsaveview)
  vim.api.nvim_win_call(header_winid, function()
    local cur = vim.fn.winsaveview()
    if cur.leftcol ~= win_view.leftcol or cur.lnum ~= header_lnum then
      vim.fn.winrestview({ topline = header_lnum, lnum = header_lnum, leftcol = win_view.leftcol })
    end
  end)
end

--- 显示 sticky header
---@param winid integer  主窗口
---@param bufnr integer
---@param separator string|false  分隔符
local function show_sticky_header(winid, bufnr, separator)
  local win_width = vim.api.nvim_win_get_width(winid)
  local win_opts = {
    win = winid,
    relative = "win",
    width = win_width,
    height = 1,
    row = 0,
    col = 0,
    focusable = false,
    style = "minimal",
    border = get_sticky_header_border(separator),
  }

  local header_winid = M._sticky_header_wins[winid]
  if not header_winid or not vim.api.nvim_win_is_valid(header_winid) then
    win_opts.noautocmd = true
    header_winid = vim.api.nvim_open_win(bufnr, false, win_opts)
    M._sticky_header_wins[winid] = header_winid
  else
    vim.api.nvim_win_set_config(header_winid, win_opts)
    if vim.api.nvim_win_get_buf(header_winid) ~= bufnr then
      vim.api.nvim_win_set_buf(header_winid, bufnr)
    end
  end

  vim.w[header_winid].csvview_sticky_header_win = true
  set_sticky_header_win_options(header_winid, winid)
end

--- 判断是否应该显示 sticky header
---@param winid integer
---@param header_lnum integer
---@param separator string|false
---@return boolean
local function should_show_sticky_header(winid, header_lnum, separator)
  local top_lnum = vim.fn.line("w0", winid)
  if top_lnum <= header_lnum then
    return false
  end

  -- 如果光标盖住了 sticky header 位置，隐藏
  local cur_lnum = vim.fn.line(".", winid)
  local header_bot_lnum = top_lnum + (separator and 1 or 0)
  if cur_lnum <= header_bot_lnum then
    return false
  end

  return true
end

--- 关闭指定窗口的 sticky header
---@param winid integer
function M.close_header_win_for(winid)
  local header_win = M._sticky_header_wins[winid]
  if not header_win then
    return
  end
  M._sticky_header_wins[winid] = nil
  if not vim.api.nvim_win_is_valid(header_win) then
    return
  end
  vim.schedule(function()
    if vim.api.nvim_win_is_valid(header_win) then
      pcall(vim.api.nvim_win_close, header_win, true)
    end
  end)
end

--- statuscolumn 回调（供 v:lua 调用）
---@param winid integer
---@return string
function M.statuscolumn(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return ""
  end
  local stc = get_statuscolumn_or_default(winid)
  local data = vim.api.nvim_eval_statusline(stc, {
    use_statuscol_lnum = vim.v.lnum,
    winid = winid,
    highlights = true,
    fillchar = " ",
  })
  return format_to_stc_string(data)
end

--- 对某个 buffer 的所有窗口执行 sticky header 刷新
---@param bufnr integer
---@param config table
function M.redraw(bufnr, config)
  local sticky_opts = config.view.sticky_header
  if not sticky_opts.enabled then
    -- 如果被全局关闭，清理所有相关窗口
    for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
      M.close_header_win_for(winid)
    end
    return
  end

  local header_lnum = 1 -- 当前设计：首行为 header

  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    if should_show_sticky_header(winid, header_lnum, sticky_opts.separator) then
      show_sticky_header(winid, bufnr, sticky_opts.separator)
      sync_horizontal_scroll(winid, M._sticky_header_wins[winid], header_lnum)
    else
      M.close_header_win_for(winid)
    end
  end
end

return M
