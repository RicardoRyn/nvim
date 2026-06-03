-- TODO: buffer order保存进session中

local M = {}

local api = vim.api
local fn = vim.fn

---@type number[]  当前所有 listed buffer，按期望顺序排列
local buffer_order = {}

local function init()
  buffer_order = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if fn.buflisted(buf) == 1 then
      table.insert(buffer_order, buf)
    end
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
end

--- 从顺序中移除一个 buffer
---@param buf number
local function remove_buffer(buf)
  for i, b in ipairs(buffer_order) do
    if b == buf then
      table.remove(buffer_order, i)
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

  -- 通知其他插件（如 heirline）重建 buffer 缓存
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })
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

-- session 恢复后，所有 buffer 已加载，重新初始化 buffer_order
api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    init()
  end,
})

init()

return M
