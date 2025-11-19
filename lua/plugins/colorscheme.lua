return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "latte",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      float = {
        transparent = false, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
      auto_integrations = true,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
