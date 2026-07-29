local M = {}

local special_mode = require("utils.special_mode")
if special_mode.is_active() then
  M.get_buffer_order = function() return {} end
  M.cycle = function() end
  M.move = function() end

  M.close = function() end
  M.pick_close = function() end
  M.close_in_direction = function() end

  M.toggle_pin = function() end
  M.is_pinned = function() return false end
  M.is_shared = function() return false end
  return M
end

local order = require("utils.buffer_actions.order")
local close = require("utils.buffer_actions.close")
local pin = require("utils.buffer_actions.pin")

M.get_buffer_order = order.get_buffer_order
M.cycle = order.cycle
M.move = order.move
M.is_shared = order.is_shared

M.close = close.close
M.pick_close = close.pick_close
M.close_in_direction = close.close_in_direction

M.toggle_pin = pin.toggle_pin
M.is_pinned = pin.is_pinned

local augroup = vim.api.nvim_create_augroup("SetupBufferActions", { clear = true })

-- Need both BufAdd and BufEnter: 
-- BufAdd misses already-loaded buffers (e.g., in other tabs); 
-- BufEnter misses when already loaded and current (e.g., opening many buffers at once).
vim.api.nvim_create_autocmd("BufAdd", {
  group = augroup,
  callback = function(args)
    local tab = vim.api.nvim_get_current_tabpage()
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf)
          and vim.fn.buflisted(args.buf) == 1
          and vim.bo[args.buf].buftype == "" then
        order.add_buffer_to_tab(tab, args.buf)
      end
    end)
  end,
})
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function(args)
    local tab = vim.api.nvim_get_current_tabpage()
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf)
          and vim.fn.buflisted(args.buf) == 1
          and vim.bo[args.buf].buftype == "" then
        order.add_buffer_to_tab(tab, args.buf)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = augroup,
  callback = function(args)
    order.remove_buffer(args.buf)
  end,
})

vim.api.nvim_create_autocmd("TabEnter", {
  group = augroup,
  callback = function()
    order.on_tab_enter()
  end,
})

vim.api.nvim_create_autocmd("TabNewEntered", {
  group = augroup,
  callback = function()
    order.on_tab_new_entered()
  end,
})

vim.api.nvim_create_autocmd("TabClosedPre", {
  group = augroup,
  callback = function()
    order.on_tab_closed()
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    order.restore()
  end,
})

order.init()

return M
