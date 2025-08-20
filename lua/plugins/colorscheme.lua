return {
  "catppuccin/nvim",
  cond = not vim.g.vscode,
  name = "catppuccin",
  priority = 1000,

  lazy = false,
  config = function()
    require("catppuccin").setup({
      flavour = "latte",
      integrations = {
        -- 开启 bufferline 支持
        bufferline = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
    vim.cmd([[highlight CursorLine guibg=#dce0e8]])
    vim.o.cursorline = true
  end,
}
