return {
  "rcarriga/nvim-dap-ui",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    require("nvim-dap-virtual-text").setup({})
    require("noice").setup()

    local dap, dapui = require("dap"), require("dapui")
    -- 启动调试时自动打开UI，关闭调试时自动关闭UI
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- DAP UI显示窗格
    dapui.setup({
      layouts = {
        {
          position = "left",
          size = 40,
          elements = {
            { id = "stacks", size = 0.2 },
            { id = "scopes", size = 0.5 },
            { id = "breakpoints", size = 0.15 },
            { id = "watches", size = 0.15 },
          },
        },
        {
          position = "bottom",
          size = 0.2,
          elements = {
            { id = "repl", size = 0.3 },
            { id = "console", size = 0.7 },
          },
        },
      },
    })

    vim.fn.sign_define( "DapBreakpoint", { text = " ", texthl = "DapBreakpoint", linehl = "", numhl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DapBreakpointCondition", linehl = "DapBreakpointCondition", numhl = "DapBreakpointCondition", })
    vim.fn.sign_define("DapStopped", { text = " ", texthl = "DapUIBreakpointsCurrentLine", linehl = "DapUIBreakpointsCurrentLine", numhl = "DapUIBreakpointsCurrentLine", })

    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function() local input = vim.fn.input("Condition for breakpoint:") dap.set_breakpoint(input) end, { desc = "Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })
    vim.keymap.set("n", "<leader>dC", dap.clear_breakpoints, { desc = "Clear Breakpoints" })
    vim.keymap.set("n", "<leader>dd", function() dap.disconnect({ terminateDebuggee = false }, function() dap.close() end) end, { desc = " Disconnect" })
    vim.keymap.set("n", "<leader>dD", function() dap.disconnect({ terminateDebuggee = true }, function() dap.close() end) end, { desc = " Disconnect (Terminate Debuggee)" })
    vim.keymap.set("n", "<leader>dfs", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.scopes) end, { desc = "Float Scopes" })
    vim.keymap.set("n", "<leader>dfS", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.sessions) end, { desc = "Float Sessions" })
    vim.keymap.set("n", "<leader>dff", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.frames) end, { desc = "Float Frames" })
    vim.keymap.set("n", "<leader>dfe", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.expression) end, { desc = "Float Expression" })
    vim.keymap.set("n", "<leader>dft", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.threads) end, { desc = "Float Threads" })
    vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = " Step into" })
    vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = " Step back" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = " Step over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = " Step out" })
    vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = " Terminate session" })
    vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
    vim.keymap.set("n", "<leader>dR", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>ds", dap.continue, { desc = " Start/Continue" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
  end,
}
