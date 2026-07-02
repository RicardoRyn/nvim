local M = {}

local special_mode = require("utils.special_mode")
if special_mode.is_active() then
  M.get_buffer_order = function()
    return {}
  end
  M.cycle = function() end
  M.move = function() end
  M.close_in_direction = function() end
  M.pick_close = function() end
  M.toggle_pin = function() end
  M.is_pinned = function()
    return false
  end
  return M
end

local order = require("utils.buffer_actions.order")
local close = require("utils.buffer_actions.close")
local pin = require("utils.buffer_actions.pin")

M.move = order.move
M.cycle = order.cycle
M.get_buffer_order = order.get_buffer_order

M.close_in_direction = close.close_in_direction
M.pick_close = close.pick_close

M.toggle_pin = pin.toggle_pin
M.is_pinned = pin.is_pinned

local augroup = vim.api.nvim_create_augroup("SetupBufferActions", { clear = true })

vim.api.nvim_create_autocmd("BufAdd", {
  group = augroup,
  callback = function(args)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) and vim.fn.buflisted(args.buf) == 1 then
        order.add_buffer_to_buffer_order(args.buf)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = augroup,
  callback = function(args)
    order.remove_buffer_from_buffer_order(args.buf)
  end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = function()
    order.save_buffer_order()
  end,
})

order.init()

return M
