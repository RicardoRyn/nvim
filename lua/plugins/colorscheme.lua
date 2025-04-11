-- 设置主题
if vim.g.vscode then
  return {}
else
  return {
    -- add catppuccin
    { "catppuccin/nvim" },

    -- Configure LazyVim to load catppuccin
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin-latte",
      },
    },
  }
end
