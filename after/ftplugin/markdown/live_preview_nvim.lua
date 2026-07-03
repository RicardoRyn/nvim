require("utils.lazy").load({
  setup = function()
    require("livepreview.config").set({
      port = 5500,
      browser = require("utils.system").is_win and "Start-Process" or "default",
      dynamic_root = false,
      sync_scroll = true,
      picker = "",
      address = "127.0.0.1",
    })
  end,
  keys = {
    { "n", "<leader>um", "<cmd>LivePreview start<cr>", { desc = "Markdown preview" } },
  },
})
