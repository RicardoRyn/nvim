return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = true,
      float = {
        transparent = true, -- enable transparent floating windows
        solid = true, -- use solid styling for floating windows, see |winborder|
      },
      auto_integrations = true,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
