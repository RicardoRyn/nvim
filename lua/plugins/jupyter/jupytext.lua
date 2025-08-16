if vim.g.vscode then
  return {}
else
  return {
    -- 环境中需要pip install jupytext命令
    "GCBallesteros/jupytext.nvim",
    cond = function()
      return vim.loop.os_uname().sysname == "Linux"
    end,
    config = true,
    opts = {
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  }
end
