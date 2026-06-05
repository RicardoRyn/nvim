local Win = require("utils.pretty_cmdline.window")

local M = {}
local SIDESCROLLOFF = 2

local OPT = {
  routes = {
    {
      match = { firstc = "/" },
      prefix = " ",
      title = "Search",
      hl = "PrettyCmdlineSearchDown",
      ft = "regex",
      relative = "editor",
    },
    {
      match = { firstc = "?" },
      prefix = " ",
      title = "Search",
      hl = "PrettyCmdlineSearchUp",
      ft = "regex",
      relative = "editor",
    },
    {
      match = { firstc = ":", pattern = "%s*he?l?p?%s+" },
      prefix = "?",
      title = "Help",
      hl = "PrettyCmdlineHelp",
      relative = "editor",
    },
    {
      match = { firstc = ":", pattern = "%s*lua%s+" },
      prefix = "",
      title = "Lua",
      hl = "PrettyCmdlineLua",
      ft = "lua",
      relative = "editor",
    },
    {
      match = { firstc = ":", pattern = "%s*lua=" },
      prefix = "",
      title = "Lua Print",
      hl = "PrettyCmdlineLua",
      ft = "lua",
      relative = "editor",
    },
    {
      match = { firstc = ":", pattern = "%s*=" },
      prefix = "",
      title = "Calculator",
      hl = "PrettyCmdlineDefault",
      ft = "regex",
      relative = "editor",
    },
    {
      match = {
        firstc = ":",
        pattern = {
          "%s+%!",
          "^%!",
        },
      },
      prefix = "$",
      title = "Filter",
      hl = "PrettyCmdlineFilter",
      ft = "bash",
      relative = "editor",
    },
    {
      match = { firstc = "", prompt = "New Name" },
      prefix = "󰥻",
      title = "LSP Rename",
      hl = "PrettyCmdlineLspRenameInput",
      relative = "cursor",
    },
    {
      match = { firstc = ":" },
      prefix = "",
      title = "Cmdline",
      hl = "PrettyCmdlineDefault",
      ft = "vim",
      relative = "editor",
    },
    {
      match = { firstc = "" },
      prefix = "󰥻",
      title = "Input",
      hl = "PrettyCmdlineInput",
      relative = "editor",
    },
  },
}

local ns_id = vim.api.nvim_create_namespace("PrettyCmdline")

---@class PrettyCmdlineState
---@field win Win
---@field pos number
---@field raw_content string
---@field route table

---@type table<number, PrettyCmdlineState>
local StatStack = {}

--- 用 extmark 在 buffer 第 0 列渲染 prefix 前缀
---@param bufnr integer
---@param prefix string
---@param hl string
---@param pos number
local function redraw_marks(bufnr, prefix, hl, pos)
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = { { prefix .. " ", hl } },
    virt_text_pos = "inline",
    right_gravity = false,
    priority = 100,
  })
end

--- 从 ext_cmdline 的 content 数组拼接出原始字符串
--- content 格式: { { chunk1, hl1 }, { chunk2, hl2 }, ... }
---@param content table
---@return string
local function concat_content(content)
  local raw = ""
  for _, chunk in ipairs(content) do
    raw = raw .. chunk[2]
  end
  return raw
end

--- 核心渲染：prefix extmark + wildmenu 位置 + 光标
---@param level number
local function redraw_ui(level)
  local stat = StatStack[level]
  if not stat or not stat.win:is_valid() then
    return
  end

  local prefix_len = #stat.route.prefix + 1

  -- 渲染 prefix 前缀到 buffer 第 0 列前面
  redraw_marks(stat.win.buf, stat.route.prefix, stat.route.hl, stat.pos)

  -- 告知 Neovim 命令行窗口的屏幕坐标，blink/wildmenu 会自动定位到下方
  local win_cfg = vim.api.nvim_win_get_config(stat.win.win)
  vim.g.ui_cmdline_pos = { win_cfg.row + 2, win_cfg.col + 2 + prefix_len }

  -- 在新版 Neovim 中直接用 nvim__redraw 把光标画到浮窗里
  vim.api.nvim_win_call(stat.win.win, function()
    pcall(vim.api.nvim_win_set_cursor, stat.win.win, { 1, stat.pos })
  end)
  pcall(vim.api.nvim__redraw, { cursor = true, flush = true, win = stat.win.win })
end

--- ext_cmdline 事件：命令行显示/更新
---@param content table    ext_cmdline 传来的内容数组
---@param pos number       光标位置（0-indexed）
---@param firstc string    首字符（":" "/" "?" ""）
---@param prompt string    输入提示文字（如 "New Name"）
---@param indent number    缩进
---@param level number     嵌套层级
---@param special any      特殊参数
function M.on_cmdline_show(content, pos, firstc, prompt, indent, level, special)
  local raw_content = concat_content(content)

  -- 路由匹配
  local route
  ---@param pat string|string[]
  ---@param str string
  ---@return boolean
  local function try_match_patterns(pat, str)
    if type(pat) == "string" then
      return str:match(pat) ~= nil
    elseif vim.isarray(pat) then
      for _, p in ipairs(pat) do
        if str:match(p) then
          return true
        end
      end
    end
    return false
  end
  for _, r in ipairs(OPT.routes) do
    local is_match = true
    local match = r.match
    if match.firstc and match.firstc ~= firstc then
      is_match = false
    end
    if match.pattern and not try_match_patterns(match.pattern, raw_content) then
      is_match = false
    end
    if match.prompt and not try_match_patterns(match.prompt, prompt) then
      is_match = false
    end
    if is_match then
      route = r
      break
    end
  end
  if not route then
    return
  end

  local prefix_len = #route.prefix + 1
  local screen_w = vim.o.columns
  local min_width = Win.resolve(0.2, screen_w)
  local content_width = math.max(min_width, #raw_content + prefix_len + SIDESCROLLOFF)

  -- cursor 相对定位用小的绝对偏移，editor 相对用百分比
  local is_cursor = route.relative == "cursor"
  local winopt = {
    height = 1,
    width = content_width,
    col = is_cursor and 1 or 0.5,
    row = is_cursor and 1 or 0.12,
    relative = route.relative,
    title = { { " " .. route.title .. " ", route.hl } },
    border = "rounded",
    focus_on_open = false,
    focusable = true,
    zindex = 400,
    ft = route.ft,
    wo = {
      number = false,
      wrap = false,
      sidescrolloff = SIDESCROLLOFF,
      virtualedit = "onemore",
      relativenumber = false,
      foldcolumn = "0",
      signcolumn = "no",
      statuscolumn = " ",
      winhighlight = "FloatBorder:" .. route.hl .. ",NormalFloat:Normal",
    },
  }

  local stat = StatStack[level]
  if stat and stat.win:is_valid() then
    stat.win:set_lines({ raw_content })
    stat.win:update(winopt)
    if route.title then
      stat.win:set_title({ { " " .. route.title .. " ", route.hl } })
    end
    stat.pos = pos
    stat.raw_content = raw_content
    stat.route = route
  else
    local new_win = Win.open(winopt, { raw_content })
    StatStack[level] = {
      win = new_win,
      pos = pos,
      raw_content = raw_content,
      route = route,
    }
  end

  redraw_ui(level)
end

--- ext_cmdline 事件：光标位置变更
---@param pos number   新的光标位置
---@param level number 嵌套层级
function M.on_cmdline_pos(pos, level)
  local stat = StatStack[level]
  if not stat then
    return
  end
  stat.pos = pos
  redraw_ui(level)
end

--- ext_cmdline 事件：命令行隐藏
---@param level number 嵌套层级
function M.on_cmdline_hide(level, _)
  local stat = StatStack[level]
  if stat and stat.win:is_valid() then
    stat.win:close()
  end
  StatStack[level] = nil
end

--- 初始化：注册高亮组 + ext_cmdline UI 事件监听
function M.setup()
  -- 注册各路由对应的高亮组（颜色链接到 MiniIcons 色板）
  local highlights = {
    PrettyCmdlineDefault = { link = "MiniIconsBlue" },
    PrettyCmdlineLua = { link = "MiniIconsAzure" },
    PrettyCmdlineHelp = { link = "MiniIconsGreen" },
    PrettyCmdlineSearchUp = { link = "MiniIconsOrange" },
    PrettyCmdlineSearchDown = { link = "MiniIconsYellow" },
    PrettyCmdlineFilter = { link = "MiniIconsRed" },
    PrettyCmdlineInput = { link = "MiniIconsCyan" },
    PrettyCmdlineLspRenameInput = { link = "MiniIconsPurple" },
  }
  for name, def in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, def)
  end

  local ns = vim.api.nvim_create_namespace("PrettyCmdlineUI")
  vim.ui_attach(ns, { ext_cmdline = true }, function(event, ...)
    local handler = M["on_" .. event]
    if type(handler) == "function" then
      handler(...)
    end
  end)
end

return M
