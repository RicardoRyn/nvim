return {
  "mfussenegger/nvim-dap-python",
  cond = not vim.g.vscode,
  dependencies = {
    "mfussenegger/nvim-dap",
    "rcarriga/nvim-dap-ui",
  },
  ft = "python",
  config = function()
    local dap = require("dap")
    local dap_python = require("dap-python")

    local debugpy_path = not SYSTEM.is_win and vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      or vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"

    dap_python.setup(debugpy_path)

    -- 强制覆盖 Adapter 以解决 Windows 弹窗
    if SYSTEM.is_win then
      local function get_project_python()
        local cwd = vim.fn.getcwd()
        local venv_python = cwd .. "/.venv/Scripts/python.exe"
        -- 寻找项目自己的解释器
        if vim.fn.filereadable(venv_python) == 1 then
          return venv_python
        else
          -- 如果找不到，就退回到系统 python 或者 mason python
          return vim.fn.exepath("python") or debugpy_path
        end
      end

      -- 强制覆盖 Adapter 以解决 Windows 弹窗
      dap.adapters.python = {
        type = "executable",
        command = debugpy_path,
        args = { "-m", "debugpy.adapter" },
        options = {
          detached = false, -- 防止 Windows 弹窗
          source_filetype = "python",
        },
      }

      for _, config in ipairs(dap.configurations.python or {}) do
        config.console = "internalConsole"
        -- 强制使用项目环境 (仅对 launch 模式生效)
        if config.request == "launch" then
          config.pythonPath = get_project_python
        end
      end
    end
  end,
}
