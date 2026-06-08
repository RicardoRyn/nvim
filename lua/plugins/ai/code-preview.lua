return {
  "Cannon07/code-preview.nvim",
  cond = not vim.g.vscode,
  config = function()
    require("code-preview").setup()
  end,
}
