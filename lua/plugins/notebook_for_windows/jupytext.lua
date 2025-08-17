return {
  "GCBallesteros/jupytext.nvim",
  cond = function()
    return vim.loop.os_uname().sysname == "Windows_NT" and not vim.g.vscode
  end,
  config = true,
  opts = {
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
  },
}
