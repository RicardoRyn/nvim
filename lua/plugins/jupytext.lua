return {
  "GCBallesteros/jupytext.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  config = true,
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}
