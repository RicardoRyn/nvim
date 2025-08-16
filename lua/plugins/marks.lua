return {
  "chentoast/marks.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  event = "VeryLazy",
  opts = {},
}
