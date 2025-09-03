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
        bufferline = true, -- 开启 bufferline 支持
        blink_cmp = true, -- 开启 cmp 的高亮
      },
    })

    vim.cmd.colorscheme("catppuccin")
    vim.cmd([[highlight CursorLine guibg=#dce0e8]])
    vim.o.cursorline = true
  end,
}
