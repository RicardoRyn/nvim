if vim.g.vscode then
  return {}
else
  return {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  }
end
