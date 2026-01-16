return {
  "mfussenegger/nvim-dap-python",
  cond = not vim.g.vscode,
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  ft = "python",
  config = function()
    local path = not SYSTEM.is_win and vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      or vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"
    require("dap-python").setup(path)
  end,
}
