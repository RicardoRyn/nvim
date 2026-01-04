return {
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  ft = "python",
  config = function()
    local path = not SYSTEM.is_win and "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python" or nil
    require("dap-python").setup(path)
  end,
}
