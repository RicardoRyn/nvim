return {
  "julienvincent/hunk.nvim",
  cond = not vim.g.vscode,
  cmd = { "DiffEditor" },
  config = function()
    require("hunk").setup({
      ui = {
        tree = {
          mode = "flat",
        },
      },
    })
  end,
}
