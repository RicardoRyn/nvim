-----------------------------------------------------------------------------//
-- buffer_move.lua — 独立 buffer 位置交换脚本（自包含，零依赖）
--
-- 无需 bufferline.nvim，直接操作 Neovim 原生 buffer list 顺序。
-- 移动后自动同步到内置 tabline 和 :bnext/:bprev 导航。
--
-- 用法:
--   local bm = require("utils.buffer_move")
--   vim.keymap.set("n", "<A-l>", function() bm.move(1)  end, { desc = "buffer move right" })
--   vim.keymap.set("n", "<A-h>", function() bm.move(-1) end, { desc = "buffer move left"  })
-----------------------------------------------------------------------------//
local M = {}

local api = vim.api
local fn = vim.fn

-----------------------------------------------------------------------------//
-- 内部状态：维护 buffer 顺序（buffer number 列表）
-----------------------------------------------------------------------------//

---@type number[]  当前所有 listed buffer，按期望顺序排列
local buffer_order = {}

-----------------------------------------------------------------------------//
-- 状态初始化：从 Neovim 当前 buffer list 读取初始顺序
-----------------------------------------------------------------------------//

local function init()
  buffer_order = {}
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if fn.buflisted(buf) == 1 then
      table.insert(buffer_order, buf)
    end
  end
end

-----------------------------------------------------------------------------//
-- 状态同步：维护 buffer_order 与 Neovim 的 buffer 增删同步
-----------------------------------------------------------------------------//

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

-----------------------------------------------------------------------------//
-- 核心：将 buffer_order 应用到 Neovim 原生 buffer list
--
-- Neovim 的 buffer list 顺序决定了 :bnext/:bprev 的导航顺序
-- 以及内置 tabline 的显示顺序。
-- 通过 :buffer N 命令可以把 buffer N 推到 list 最前面。
-- 因此，按 REVERSE 顺序逐一遍历 buffer_order 中的 buffer，
-- 即可将整个 list 设为期望的顺序。
--
-- 为不影响用户界面，所有 buffer 切换在临时窗口中完成。
-----------------------------------------------------------------------------//

local function apply_order_to_neovim()
  cleanup()

  local current_buf = api.nvim_get_current_buf()

  -- 反向遍历：最后一个先访问 → 最终第一个在最前面
  -- 在当前窗口直接切换 buffer，不会创建新的 buffer
  for i = #buffer_order, 1, -1 do
    local buf = buffer_order[i]
    if api.nvim_buf_is_valid(buf) and fn.buflisted(buf) == 1 then
      pcall(vim.cmd, "noautocmd buffer " .. buf)
    end
  end

  -- 恢复到用户正在查看的 buffer
  if api.nvim_buf_is_valid(current_buf) then
    pcall(vim.cmd, "noautocmd buffer " .. current_buf)
  end

  -- 通知其他插件（如 heirline）重建 buffer 缓存
  api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })
end

-----------------------------------------------------------------------------//
-- 公开 API
-----------------------------------------------------------------------------//

--- 将当前 buffer 向左或向右移动一位（与相邻 buffer 交换位置）
--- 到达边界时什么都不做。
---@param direction number  1 = 右移, -1 = 左移
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
    return -- 边界
  end

  -- 交换
  buffer_order[index], buffer_order[next_index] = buffer_order[next_index], buffer_order[index]

  -- 应用到 Neovim 原生 buffer list
  apply_order_to_neovim()
end

--- 调试用：查看当前 buffer 顺序
---@return number[]
function M.order()
  cleanup()
  return vim.deepcopy(buffer_order)
end

-----------------------------------------------------------------------------//
-- Autocmds：监听 buffer 增删，自动同步
-----------------------------------------------------------------------------//

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

-----------------------------------------------------------------------------//
-- 启动
-----------------------------------------------------------------------------//

init()

return M
