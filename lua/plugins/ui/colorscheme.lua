return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha, auto
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = not SYSTEM.is_win,
      float = {
        transparent = true,
        solid = true,
      },
      auto_integrations = true,
      integrations = {
        avante = false,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
