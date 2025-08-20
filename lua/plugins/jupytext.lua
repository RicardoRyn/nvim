return {
  "GCBallesteros/jupytext.nvim",
  cond = not vim.g.vscode,
  config = true,
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}
