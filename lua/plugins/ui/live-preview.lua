return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>um", "<cmd>LivePreview start<cr>", desc = "Live Preview (Start)" },
  },
  config = function()
    require("livepreview.config").set({
      port = 5500,
      browser = SYSTEM.is_win and "Start-Process" or "default",
      dynamic_root = false,
      sync_scroll = true,
      picker = "",
      address = "127.0.0.1",
    })
  end,
}
