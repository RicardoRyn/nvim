--------------------------------------------------------------------------------
-- 浮动窗口 -- 精简版（从 popup/window.lua 摘抄）
--------------------------------------------------------------------------------
local M = {}

---@class WinOpt
---@field width number
---@field height number
---@field row number
---@field col number
---@field anchor? 'NW'|'NE'|'SW'|'SE'
---@field relative? 'editor'|'win'|'cursor'
---@field border? 'rounded'|'single'|'none'
---@field focusable? boolean
---@field focus_on_open? boolean
---@field zindex? integer
---@field ft? string
---@field wo? table<string, any>
---@field bo? table<string, any>
---@field noautocmd boolean|nil

---@class Win
---@field buf integer
---@field win integer|nil
---@field opts WinOpt
---@field _augroup integer|nil
---@field _closed boolean
local Win = {}
Win.__index = Win

---@type WinOpt
local WINOPT_DEFAULT = {
  width = 0.6,
  height = 0.4,
  row = 0.5,
  col = 0.5,
  anchor = "NW",
  relative = "editor",
  border = "rounded",
  focusable = true,
  focus_on_open = false,
  zindex = 50,
  ft = "",
  wo = { number = false },
  bo = {},
}

--- 把 0~1 的小数按比例换算为像素值，整数直接返回
---@param val number
---@param max_val number
---@return number
local function resolve(val, max_val)
  if type(val) == "number" and val > 0 and val < 1 then
    return math.floor(val * max_val)
  end
  return val
end

M.resolve = resolve

--- 根据 self.opts 构造 nvim_open_win 所需的 config table
---@return table
function Win:_build_config()
  local columns = vim.o.columns
  local lines = vim.o.lines

  local w = resolve(self.opts.width, columns)
  local h = resolve(self.opts.height, lines)

  -- row = 0.5 表示垂直居中
  local r = self.opts.row == 0.5 and math.floor((lines - h) / 2) or resolve(self.opts.row, lines)

  -- col = 0.5 表示水平居中
  local c = self.opts.col == 0.5 and math.floor((columns - w) / 2) or resolve(self.opts.col, columns)

  local cfg = {
    relative = self.opts.relative,
    width = math.max(1, w),
    height = math.max(1, h),
    row = r,
    col = c,
    anchor = self.opts.anchor,
    border = self.opts.border,
    focusable = self.opts.focusable,
    zindex = self.opts.zindex,
    noautocmd = self.opts.noautocmd or false,
    style = "minimal",
  }

  if self.opts.title then
    cfg.title = self.opts.title
    cfg.title_pos = self.opts.title_pos or "center"
  end

  return cfg
end

--- 注册 autocmd：WinClosed 清理 + VimResized 跟随编辑器尺寸变化
function Win:_setup_autocmds()
  local group = "ModulesWin_" .. self.buf
  self._augroup = vim.api.nvim_create_augroup(group, { clear = true })

  -- 窗口被外部关闭时清理内部状态
  vim.api.nvim_create_autocmd("WinClosed", {
    group = self._augroup,
    pattern = tostring(self.win),
    once = true,
    callback = function()
      self:_on_closed()
    end,
  })

  -- 编辑器尺寸变化时重新计算窗口位置/大小
  vim.api.nvim_create_autocmd("VimResized", {
    group = self._augroup,
    callback = function()
      if self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_set_config(self.win, self:_build_config())
      end
    end,
  })
end

--- 窗口关闭后的清理逻辑
function Win:_on_closed()
  if self._closed then
    return
  end
  self._closed = true
  self.win = nil
  if self._augroup then
    pcall(vim.api.nvim_del_augroup_by_id, self._augroup)
    self._augroup = nil
  end
end

--- 打开浮动窗口
---@param lines? string[]
---@return Win
function Win:open(lines)
  if not self.buf or not vim.api.nvim_buf_is_valid(self.buf) then
    self.buf = vim.api.nvim_create_buf(false, true)
    self._closed = false
  end

  -- 设置 buffer 选项
  local bo = vim.tbl_extend("force", {
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
  }, self.opts.bo or {})
  if self.opts.ft and self.opts.ft ~= "" then
    bo.filetype = self.opts.ft
  end
  for k, v in pairs(bo) do
    vim.bo[self.buf][k] = v
  end

  -- 写入初始内容
  if lines then
    vim.bo[self.buf].modifiable = true
    vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
    vim.bo[self.buf].modifiable = false
  end

  -- 打开或重配窗口
  local cfg = self:_build_config()
  if not self.win or not vim.api.nvim_win_is_valid(self.win) then
    self.win = vim.api.nvim_open_win(self.buf, self.opts.focus_on_open ~= false, cfg)
  else
    vim.api.nvim_win_set_config(self.win, cfg)
  end

  -- 设置窗口选项
  for k, v in pairs(self.opts.wo or {}) do
    vim.wo[self.win][k] = v
  end

  self:_setup_autocmds()

  return self
end

--- 关闭浮动窗口
---@return boolean
function Win:close()
  if self._closed then
    return false
  end
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    return true
  end
  self:_on_closed()
  return false
end

--- 判断窗口是否有效
---@return boolean
function Win:is_valid()
  return self.win ~= nil and vim.api.nvim_win_is_valid(self.win)
end

--- 更新 buffer 内容
---@param lines string[]
---@param start_line? integer
---@param end_line? integer
function Win:set_lines(lines, start_line, end_line)
  vim.bo[self.buf].modifiable = true
  vim.api.nvim_buf_set_lines(self.buf, start_line or 0, end_line or -1, false, lines)
  vim.bo[self.buf].modifiable = false
  return self
end

--- 设置窗口标题
---@param title string|table
function Win:set_title(title)
  self.opts.title = title
  if self:is_valid() then
    vim.api.nvim_win_set_config(self.win, {
      title = title,
      title_pos = self.opts.title_pos or "center",
    })
  end
  return self
end

--- 合并新配置并重绘窗口（动态宽度/位置的核心）
---@param new_opts WinOpt
function Win:update(new_opts)
  self.opts = vim.tbl_extend("force", self.opts, new_opts)
  if self:is_valid() then
    vim.api.nvim_win_set_config(self.win, self:_build_config())
    for k, v in pairs(self.opts.wo or {}) do
      vim.wo[self.win][k] = v
    end
  end
  return self
end

--- 创建 Win 实例
---@param opts? WinOpt
---@return Win
function M.create(opts)
  return setmetatable({
    opts = vim.tbl_deep_extend("force", WINOPT_DEFAULT, opts or {}),
    _closed = false,
  }, Win)
end

--- 快捷方法：创建并打开
---@param opts? WinOpt
---@param lines? string[]
---@return Win
function M.open(opts, lines)
  return M.create(opts):open(lines)
end

return M
