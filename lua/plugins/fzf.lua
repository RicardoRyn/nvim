-- 原<leader>fF等快捷键无效，重新设置命令
if vim.g.vscode then
  return {}
else
  return {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>fF", "<cmd>FzfLua files cwd=%:p:h<cr>", desc = "Find files (cwd)" },
      { "<leader>fR", "<cmd>FzfLua oldfiles cwd=%:p:h<cr>", desc = "Recent (cwd)" },
      { "<leader>fC", "<cmd>FzfLua commands<cr>", desc = "Find commands" },
    },
  }
end
