return {
  "monkoose/neocodeium",
  -- event = "VeryLazy",
  lazy = false,
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()
    vim.keymap.set("i", "<C-y>", neocodeium.accept)
    vim.keymap.set("i", "<C-w>", neocodeium.accept_word)
    vim.keymap.set("i", "<A-[>", neocodeium.cycle)
    vim.keymap.set("i", "<A-]>", neocodeium.cycle)
  end,
}
