return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "latte", -- latte, frappe, macchiato, mocha, auto
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      float = {
        transparent = true,
        solid = true,
      },
      auto_integrations = true,
    })
    vim.cmd.colorscheme("catppuccin")
    vim.cmd([[highlight CursorLine guibg=#dce0e8]])
  end,
}
