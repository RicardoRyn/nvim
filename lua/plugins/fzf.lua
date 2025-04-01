-- 自定义部分快捷键
if vim.g.vscode then
  return {}
else
  return {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>fF", "<cmd>FzfLua files cwd=%:p:h<cr>", desc = "Find files (cwd)" },
      { "<leader>fR", "<cmd>FzfLua oldfiles cwd=%:p:h<cr>", desc = "Recent (cwd)" },
    },
  }
end
