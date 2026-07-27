if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  local MiniNotify = require("mini.notify")

  local win_config = function()
    local has_statusline = vim.o.laststatus > 0
    local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
  end
  MiniNotify.setup({ window = { config = win_config } })
  vim.keymap.set("n", "<leader>nn", function() MiniNotify.show_history() end, { desc = "Notification" })
  vim.keymap.set("n", "<leader>nm", "<cmd>messages<cr>", { desc = "Messages" })
end)
