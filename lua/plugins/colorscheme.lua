-- 设置主题
if vim.g.vscode then
  return {}
else
  return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },

    -- Configure LazyVim to load gruvbox
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "tokyonight",
      },
    },
  }
end
