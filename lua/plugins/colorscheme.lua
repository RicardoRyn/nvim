return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "latte", -- latte, frappe, macchiato, mocha, auto
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      auto_integrations = true,
    })
    vim.cmd.colorscheme("catppuccin")

    vim.cmd([[highlight CursorLine guibg=#dce0e8]])
    vim.o.cursorline = true
  end,
}
