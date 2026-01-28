-- Debug utilities
_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.bt = function()
  Snacks.debug.backtrace()
end

if vim.fn.has("nvim-0.11") == 1 then
  vim._print = function(_, ...)
    dd(...)
  end
else
  vim.print = dd
end
