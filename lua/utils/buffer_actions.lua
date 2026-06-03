local M = {}

local api = vim.api
local fn = vim.fn

---@type number[]  当前所有 listed buffer，按期望顺序排列
local buffer_order = {}

--- 将 bufnr 映射为完整文件名（用于持久化）
---@param buf number
---@return string|nil
local function buf_to_name(buf)
  local name = api.nvim_buf_get_name(buf)
  if name == "" then
    return nil -- [No Name] 不持久化
  end
  return fn.fnamemodify(name, ":p")
end

--- 将 buffer_order 序列化到 g:BufferMove_Order（文件名 JSON 数组）
local function save_order()
  local names = {}
  for _, buf in ipairs(buffer_order) do
    local name = buf_to_name(buf)
    if name then
      names[#names + 1] = name
    end
  end
  vim.g.BufferMove_Order = vim.json.encode(names)
end

--- 从 g:BufferMove_Order 恢复 buffer_order
--- 根据文件名匹配当前 bufnr，若找不到则跳过
---@return boolean
local function restore_order()
  local raw = vim.g.BufferMove_Order
  if not raw or raw == "" then
    return false
  end
  local ok, names = pcall(vim.json.decode, raw)
  if not ok or type(names) ~= "table" then
    return false
  end

  -- 构建 filename → bufnr 映射表
  local name_to_buf = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    local name = buf_to_name(buf)
    if name then
      name_to_buf[name] = buf
    end
  end

  local restored = {}
  local seen = {}
  for _, name in ipairs(names) do
    local buf = name_to_buf[name]
    if buf and fn.buflisted(buf) == 1 then
      restored[#restored + 1] = buf
      seen[buf] = true
    end
  end

  -- 追加本次 session 才有的新 buffer（未出现在已保存顺序中的）
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if not seen[buf] and fn.buflisted(buf) == 1 then
      restored[#restored + 1] = buf
      seen[buf] = true
    end
  end

  buffer_order = restored
  save_order() -- 补全缺失/新增的 buffer 到持久化内容
  return true
end

--- 首次启动，还没有保存过顺序，从当前 buffer list 初始化
local function init()
  if not restore_order() then
    buffer_order = {}
    for _, buf in ipairs(api.nvim_list_bufs()) do
      if fn.buflisted(buf) == 1 then
        buffer_order[#buffer_order + 1] = buf
      end
    end
    save_order()
  end
end

--- 添加一个 buffer 到顺序末尾（去重）
---@param buf number
local function add_buffer(buf)
  if fn.buflisted(buf) == 0 then
    return
  end
  for _, b in ipairs(buffer_order) do
    if b == buf then
      return
    end
  end
  buffer_order[#buffer_order + 1] = buf
  save_order()
end

--- 从顺序中移除一个 buffer
---@param buf number
local function remove_buffer(buf)
  for i, b in ipairs(buffer_order) do
    if b == buf then
      table.remove(buffer_order, i)
      save_order()
      return
    end
  end
end

--- 清理 buffer_order 中已失效的 buffer
local function cleanup()
  local valid = {}
  for _, buf in ipairs(buffer_order) do
    if api.nvim_buf_is_valid(buf) and fn.buflisted(buf) == 1 then
      valid[#valid + 1] = buf
    end
  end
  buffer_order = valid
end

--- 将当前 buffer 向左或向右循环移动一位
--- 到达边界时循环到另一端
---@param direction number  1 = 右移1位, -1 = 左移1位
function M.cycle(direction)
  cleanup()

  local current_buf = api.nvim_get_current_buf()
  local index
  for i, buf in ipairs(buffer_order) do
    if buf == current_buf then
      index = i
      break
    end
  end

  local next_index = index + direction

  if next_index < 1 then
    pcall(vim.cmd, "buffer " .. buffer_order[#buffer_order])
  elseif next_index > #buffer_order then
    pcall(vim.cmd, "buffer " .. buffer_order[1])
  else
    pcall(vim.cmd, "buffer " .. buffer_order[next_index])
  end
end

--- 将当前 buffer 向左或向右移动一位（与相邻 buffer 交换位置）
--- 到达边界时什么都不做
---@param direction number  1 = 右移1位, -1 = 左移1位
function M.move(direction)
  cleanup()

  local current_buf = api.nvim_get_current_buf()

  -- 找到当前 buffer 在 buffer_order 中的位置
  local index
  for i, buf in ipairs(buffer_order) do
    if buf == current_buf then
      index = i
      break
    end
  end
  if not index then
    return
  end

  local next_index = index + direction
  if next_index < 1 or next_index > #buffer_order then
    -- 边界情况
    return
  end

  -- 交换
  buffer_order[index], buffer_order[next_index] = buffer_order[next_index], buffer_order[index]

  -- 持久化 + 通知 heirline 刷新
  save_order()
  api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })
end

--- 调试用：查看当前 buffer 顺序
---@return number[]
function M.order()
  cleanup()
  return vim.deepcopy(buffer_order)
end

local augroup = api.nvim_create_augroup("BufferMove", { clear = true })

api.nvim_create_autocmd("BufAdd", {
  group = augroup,
  callback = function(args)
    vim.schedule(function()
      if api.nvim_buf_is_valid(args.buf) and fn.buflisted(args.buf) == 1 then
        add_buffer(args.buf)
      end
    end)
  end,
})

api.nvim_create_autocmd("BufWipeout", {
  group = augroup,
  callback = function(args)
    remove_buffer(args.buf)
  end,
})

api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    restore_order()
  end,
})

init()

return M
