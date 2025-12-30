return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "auto", -- latte, frappe, macchiato, mocha, auto
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = vim.loop.os_uname().sysname ~= "Windows_NT",
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
