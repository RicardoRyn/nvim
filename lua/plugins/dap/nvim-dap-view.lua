return {
  "igorlfs/nvim-dap-view",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  version = "1.*",
  opts = {
    winbar = {
      sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
      default_section = "repl",
    },
    windows = {
      -- `prev` is the last used position, might be nil
      position = function(prev)
        local wins = vim.api.nvim_tabpage_list_wins(0)
        -- Restores previous position if terminal is visible
        if vim.iter(wins):find(function(win)
          return vim.w[win].dapview_win_term
        end) then
          return prev
        end

        return vim.tbl_count(vim
          .iter(wins)
          :filter(function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            local valid_buftype =
              vim.tbl_contains({ "", "help", "prompt", "quickfix", "terminal" }, vim.bo[buf].buftype)
            local dapview_win = vim.w[win].dapview_win or vim.w[win].dapview_win_term
            return valid_buftype and not dapview_win
          end)
          :totable()) > 1 and "below" or "right"
      end,
      size = function(pos)
        return pos == "below" and 0.25 or 0.3
      end,
      terminal = {
        -- `pos` is the position for the regular window
        position = function(pos)
          return pos == "below" and "right" or "below"
        end,
        size = 0.5,
      },
    },
    auto_toggle = true,
  },
  -- stylua: ignore
  config = function(_, opts)
    require("dap-view").setup(opts)

    local icon = require("utils.icons").dap
    vim.fn.sign_define("DapStopped", { text = icon.Stopped, texthl = "DapUIBreakpointsCurrentLine", linehl = "RedrawDebugComposed", numhl = "DapUIBreakpointsCurrentLine", })
    vim.fn.sign_define( "DapBreakpoint", { text = icon.BreakpointData, texthl = "DapBreakpoint", linehl = "RedrawDebugRecompose", numhl = "DapBreakpoint" })
    vim.fn.sign_define("DapBreakpointCondition", { text = icon.BreakpointConditional, texthl = "DapBreakpointCondition", linehl = "RedrawDebugClear", numhl = "DapBreakpointCondition", })

    local dap  = require("dap")
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function() local input = vim.fn.input("Condition for breakpoint:") dap.set_breakpoint(input) end, { desc = "Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })
    vim.keymap.set("n", "<leader>dC", dap.clear_breakpoints, { desc = "Clear Breakpoints" })
    vim.keymap.set("n", "<leader>dd", function() dap.disconnect({ terminateDebuggee = true }, function() dap.close() end) end, { desc = " Disconnect (Terminate Debuggee)" })
    vim.keymap.set("n", "<leader>dD", function() dap.disconnect({ terminateDebuggee = false }, function() dap.close() end) end, { desc = " Disconnect" })
    vim.keymap.set("n", "<leader>dfe", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.expression) end, { desc = "Float Expression" })
    vim.keymap.set("n", "<leader>dff", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.frames) end, { desc = "Float Frames" })
    vim.keymap.set("n", "<leader>dfs", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.scopes) end, { desc = "Float Scopes" })
    vim.keymap.set("n", "<leader>dfS", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.sessions) end, { desc = "Float Sessions" })
    vim.keymap.set("n", "<leader>dft", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.threads) end, { desc = "Float Threads" })
    vim.keymap.set("n", "<leader>dh", require("dap.ui.widgets").hover, { desc = "Hover" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = " Step into" })
    vim.keymap.set("n", "<leader>dk", dap.step_out, { desc = " Step back" })
    vim.keymap.set("n", "<leader>dl", function() require("osv").launch({ port = 8086 }) end, { desc = "Launch OSV server" })
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = " Step over" })
    vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = " Step out" })
    vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = " Terminate session" })
    vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
    vim.keymap.set("n", "<leader>dR", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>ds", dap.continue, { desc = " Start/Continue" })
    vim.keymap.set("n", "<leader>du", function () require("dap-view").toggle() end, { desc = "Toggle UI" })
    vim.keymap.set("n", "<leader>dv", function () require("dap-view").virtual_text_toggle() end, { desc = "Toggle Virtual Text" })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "dap-view", "dap-repl", "terminal" },
      callback = function(ev)
        vim.keymap.set("n", "<S-h>", function () require("dap-view").navigate({count = -1, wrap = false, type = "views"}) end, { buffer = ev.buf, desc = "Views prev" })
        vim.keymap.set("n", "<S-l>", function () require("dap-view").navigate({count = 1, wrap = false, type = "views"}) end, { buffer = ev.buf, desc = "Views next" })
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ev)
            if vim.bo[ev.buf].buftype == "terminal" then
                vim.keymap.set("n", "<S-h>", function () require("dap-view").navigate({count = -1, wrap = false, type = "views"}) end, { buffer = ev.buf })
                vim.keymap.set("n", "<S-l>", function () require("dap-view").navigate({count = 1, wrap = false, type = "views"}) end, { buffer = ev.buf })
            end
        end,
    })
  end,
}
