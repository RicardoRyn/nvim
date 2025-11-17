return {
  "JezerM/oil-lsp-diagnostics.nvim",
  cond = not vim.g.vscode,
  dependencies = { "stevearc/oil.nvim" },
  opts = {
    diagnostic_symbols = {
      error = require("utils.icons").diagnostics.error,
      warn = require("utils.icons").diagnostics.warn,
      info = require("utils.icons").diagnostics.info,
      hint = require("utils.icons").diagnostics.hint,
    },
  },
}
