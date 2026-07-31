if vim.g.vscode then
  return
end

local dap
local widgets

require("utils.lazy").safely({
  setup = function()
    dap = require("dap")
    widgets = require("dap.ui.widgets")

    local icon = require("utils.icons").dap
    vim.fn.sign_define("DapStopped", {
      text = icon.Stopped,
      texthl = "DapUIBreakpointsCurrentLine",
      linehl = "RedrawDebugComposed",
      -- numhl = "DapUIBreakpointsCurrentLine",
    })
    vim.fn.sign_define("DapBreakpoint", {
      text = icon.BreakpointData,
      texthl = "DapBreakpoint",
      -- linehl = "RedrawDebugRecompose",
      -- numhl = "DapBreakpoint",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
      text = icon.BreakpointConditional,
      texthl = "DapBreakpointCondition",
      -- linehl = "RedrawDebugClear",
      -- numhl = "DapBreakpointCondition",
    })
    require("dap-view").setup({
      winbar = {
        sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "sessions", "repl", "console" },
        default_section = "console",
      },
      windows = {
        position = "right",
        size = 0.4,
        terminal = {
          position = function(pos)
            return pos == "below" and "right" or "below"
          end,
          size = 0.5,
        },
      },
      auto_toggle = true,
      render = {
        sort_variables = function(a, b)
          return a.name < b.name
        end,
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { "n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug breakpoint" } },
    { "n", "<leader>dB", function()
      local input = require("mini.input").get({
        prompt = "Condition for breakpoint: ",
        scope = "cursor",
      })
      dap.set_breakpoint(input)
    end, { desc = "Debug conditional breakpoint" } },
    { "n", "<leader>dc", function() dap.run_to_cursor() end, { desc = "Debug run to cursor" } },
    { "n", "<leader>dC", function() dap.clear_breakpoints() end, { desc = "Debug clear breakpoints" } },
    -- TODO: 未来取消注释，需要先移除使用<leader>dd的习惯
    -- { "n", "<leader>dd", function() dap.disconnect({ terminateDebuggee = true }) end, { desc = "Debug  Disconnect (Terminate Debuggee)" } },
    -- { "n", "<leader>dD", function() dap.disconnect({ terminateDebuggee = false }) end, { desc = "Debug  Disconnect" } },
    { "n", "<leader>dfe", function() widgets.centered_float(widgets.expression) end, { desc = "Debug float expression" } },
    { "n", "<leader>dff", function() widgets.centered_float(widgets.frames) end, { desc = "Debug float frames" } },
    { "n", "<leader>dfS", function() widgets.centered_float(widgets.scopes) end, { desc = "Debug float scopes" } },
    { "n", "<leader>dfs", function() widgets.centered_float(widgets.sessions) end, { desc = "Debug float sessions" } },
    { "n", "<leader>dft", function() widgets.centered_float(widgets.threads) end, { desc = "Debug float threads" } },
    { "n", "<leader>dh", function() widgets.hover() end, { desc = "Debug hover" } },
    { "n", "<leader>di", function() dap.step_into() end, { desc = "Debug  Step into" } },
    { "n", "<leader>dk", function() dap.step_out() end, { desc = "Debug  Step back" } },
    { "n", "<leader>dl", function() require("osv").launch({ port = 8086 }) end, { desc = "Debug launch OSV server" } },
    { "n", "<leader>do", function() dap.step_over() end, { desc = "Debug  Step over" } },
    { "n", "<leader>dO", function() dap.step_out() end, { desc = "Debug  Step out" } },
    { "n", "<leader>dt", function() dap.terminate() end, { desc = "Debug  Terminate session" } },
    { "n", "<leader>dr", function() dap.restart() end, { desc = "Debug restart" } },
    { "n", "<leader>dR", function() dap.repl.toggle() end, { desc = "Debug toggle REPL" } },
    { "n", "<leader>ds", function() dap.continue() end, { desc = "Debug  Start/Continue" } },
    { "n", "<leader>du", function() require("dap-view").toggle() end, { desc = "Debug toggle UI" } },
    { "n", "<leader>dv", function() require("dap-view").virtual_text_toggle() end, { desc = "Debug toggle virtual text" } },
  },
})

-- Keymaps for navigating between dap-view windows or cycling buffers if not in a dap-view window
local function navigate_or_cycle(direction)
  local ok, state = pcall(require, "dap-view.state")
  if ok and state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
    require("dap-view").navigate({ count = direction, wrap = false, type = "views" })
  else
    require("utils.buffer_actions.order").cycle(direction)
  end
end

local augroup = vim.api.nvim_create_augroup("SetupNvimDAPView", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "dap-view", "dap-repl", "terminal" },
  callback = function(ev)
    vim.keymap.set("n", "<S-h>", function()
      navigate_or_cycle(-1)
    end, { buffer = ev.buf, desc = "Views prev" })
    vim.keymap.set("n", "<S-l>", function()
      navigate_or_cycle(1)
    end, { buffer = ev.buf, desc = "Views next" })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = "*",
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "terminal" then
      vim.keymap.set("n", "<S-h>", function()
        navigate_or_cycle(-1)
      end, { buffer = ev.buf })
      vim.keymap.set("n", "<S-l>", function()
        navigate_or_cycle(1)
      end, { buffer = ev.buf })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "dap-view-term",
  callback = function(event)
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = event.buf, silent = true })
  end,
})
