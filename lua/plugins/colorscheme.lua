-- 设置主题
if vim.g.vscode then
  return {}
else
  return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },
    { "catppuccin/nvim" },

    -- Configure LazyVim to load gruvbox
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin-latte",
      },
    },
  }
end
