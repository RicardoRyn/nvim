local M = {}

---@type number[]  当前所有 listed buffer，按期望顺序排列
local buffer_order = {}

--- 选择关闭状态（对外暴露，以便继承类可读取，用于可视化字母选择渲染）
---@type boolean  启用时，标签栏将显示字母选择符，而非缓冲区编号。
M.is_picking = false

---@type table<number, string>  将缓冲区编号（bufnr）映射为在选取模式（pick mode）下分配的单字母快捷键
M.pick_letters = {}

---以主键盘区字母为首选的快捷键方案，最多支持 42 个缓冲区
local pick_alphabet = "asdfghjklqwertyuiopzxcvbnm1234567890"

---关闭指定buffer
---@param buf number
local function close_buffer(buf)
  local ok_snacks, snacks_bufdelete = pcall(Snacks, "bufdelete")
  if ok_snacks then
    snacks_bufdelete(buf)
  else
    pcall(vim.api.nvim_buf_delete, buf, { force = false })
  end
end

---将 bufnr 映射为完整文件名（用于持久化）
---@param buf number
---@return string|nil
local function buf_to_name(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil -- [No Name] 不持久化
  end
  return vim.fn.fnamemodify(name, ":p")
end

---将 buffer_order 序列化到 g:BufferMove_Order（文件名 JSON 数组）
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

---从 g:BufferMove_Order 恢复 buffer_order，并关闭其他程序打开的闲散 buffer
---@return boolean
local function restore_order()
  local raw = vim.g.BufferMove_Order

  -- 没有保存过顺序
  if not raw or raw == "" then
    return false
  end
  local ok, names = pcall(vim.json.decode, raw)
  if not ok or type(names) ~= "table" then
    return false
  end

  local restored = {}
  for _, name in ipairs(names) do
    local buf = vim.fn.bufnr(name)
    restored[#restored + 1] = buf
  end
  buffer_order = restored

  -- 关闭其他程序打开的闲散buffer，例如jj desc
  for _, buf_real in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf_real) == 1 then
      if not vim.tbl_contains(buffer_order, buf_real) then
        close_buffer(buf_real)
      end
    end
  end

  return true
end

---首次启动，还没有保存过顺序，从当前 buffer list 初始化
local function init()
  if not restore_order() then
    buffer_order = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.buflisted(buf) == 1 then
        buffer_order[#buffer_order + 1] = buf
      end
    end
  end
end

---添加一个 buffer 到顺序末尾（去重）
---@param buf number
local function add_buffer_to_buffer_order(buf)
  if vim.fn.buflisted(buf) == 0 then
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

---从顺序中移除一个 buffer
---@param buf number
local function remove_buffer_from_buffer_order(buf)
  for i, b in ipairs(buffer_order) do
    if b == buf then
      table.remove(buffer_order, i)
      save_order()
      return
    end
  end
end

---为 buffer_order 中的每个 buffer 分配唯一的单字母快捷键
---优先使用文件名首字母（小写），若已占用则回退到 pick_alphabet 中首个未使用字母
local function assign_pick_letters()
  M.pick_letters = {}
  local used = {}
  for _, buf in ipairs(buffer_order) do
    local name = vim.api.nvim_buf_get_name(buf)
    local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or ""
    local first_char = filename:sub(1, 1):lower()

    local letter = nil
    if first_char ~= "" and not used[first_char] and pick_alphabet:find(first_char, 1, true) then
      letter = first_char
    else
      for c in pick_alphabet:gmatch(".") do
        if not used[c] then
          letter = c
          break
        end
      end
    end
    if letter then
      M.pick_letters[buf] = letter
      used[letter] = true
    end
  end
end

---将当前 buffer 向左或向右循环移动一位
---到达边界时循环到另一端
---@param direction number  1 = 右移1位, -1 = 左移1位
function M.cycle(direction)
  local current_buf = vim.api.nvim_get_current_buf()
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

---将当前 buffer 向左或向右移动一位（与相邻 buffer 交换位置）
---到达边界时什么都不做
---@param direction number  1 = 右移1位, -1 = 左移1位
function M.move(direction)
  local current_buf = vim.api.nvim_get_current_buf()

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
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })
  save_order()
end

---Buffer pick close：在每个 buffer tab 上渲染字母快捷键，按对应字母关闭 buffer
---与 bufferline.nvim 的 BufferLinePickClose 行为一致
function M.pick_close()
  if M.is_picking then
    return
  end

  assign_pick_letters()
  M.is_picking = true
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })

  -- 等待用户输入字母
  local ok, char = pcall(vim.fn.getchar)
  if ok and char then
    local letter = vim.fn.nr2char(char):lower()
    for buf, l in pairs(M.pick_letters) do
      if l == letter then
        close_buffer(buf)
        break
      end
    end
  end

  -- 清理 pick 状态，恢复正常 tabline 渲染
  M.is_picking = false
  M.pick_letters = {}
  vim.api.nvim_exec_autocmds("User", { pattern = "BufferMoveOrderChanged", modeline = false })
end

---关闭当前缓冲区左侧或右侧的所有标签页
---@alias Direction "'left'" | "'right'"
---@param direction Direction
function M.close_in_direction(direction)
  local current_buf = vim.api.nvim_get_current_buf()

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

  -- 收集需要关闭的 buffer
  local to_close = {}
  if direction == "left" then
    for i = 1, index - 1 do
      to_close[#to_close + 1] = buffer_order[i]
    end
  else
    for i = index + 1, #buffer_order do
      to_close[#to_close + 1] = buffer_order[i]
    end
  end

  for _, buf in ipairs(to_close) do
    close_buffer(buf)
  end
end

--- 调试用：查看当前 buffer 顺序
---@return number[]
function M.order()
  return vim.deepcopy(buffer_order)
end

local augroup = vim.api.nvim_create_augroup("BufferMove", { clear = true })

vim.api.nvim_create_autocmd("BufAdd", {
  group = augroup,
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) and vim.fn.buflisted(args.buf) == 1 then
        add_buffer_to_buffer_order(args.buf)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = augroup,
  callback = function(args)
    remove_buffer_from_buffer_order(args.buf)
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    restore_order()
  end,
})

init()

return M
