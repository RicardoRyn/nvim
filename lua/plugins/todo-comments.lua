return {
  "folke/todo-comments.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true, -- show icons in the signs column
    sign_priority = 8, -- sign priority
    keywords = {
      FIX = {
        icon = require("config.icons").comments.fix, -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = require("config.icons").comments.todo, color = "todo" },
      HACK = { icon = require("config.icons").comments.hack, color = "warning" },
      WARN = { icon = require("config.icons").comments.warn, color = "warning", alt = { "WARNING", "XXX" } },
      PERF = {
        icon = require("config.icons").comments.perf,
        color = "perf",
        alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
      },
      TEST = { icon = require("config.icons").comments.test, color = "info", alt = { "TESTING", "PASSED", "FAILED" } },
      NOTE = { icon = require("config.icons").comments.note, color = "hint", alt = { "INFO" } },
    },
    gui_style = {
      fg = "ITALIC", -- The gui style to use for the fg highlight group.
      bg = "BOLD", -- The gui style to use for the bg highlight group.
    },
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      todo = { "#f55e44" },
      warning = { "DiagnosticWarn", "WarningMsg" },
      perf = { "#6a2cbc" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "#000000" },
    },
  },
}
