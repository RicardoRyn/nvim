local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {

  condition = conditions.has_diagnostics,
  static = {
    error_icon = require("utils.icons").diagnostics.error,
    warn_icon = require("utils.icons").diagnostics.warn,
    info_icon = require("utils.icons").diagnostics.info,
    hint_icon = require("utils.icons").diagnostics.hint,
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { "DiagnosticChanged", "BufEnter" },

  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = { fg = utils.get_highlight("DiagnosticError").fg },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = { fg = utils.get_highlight("DiagnosticWarn").fg },
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = { fg = utils.get_highlight("DiagnosticInfo").fg },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints .. " ")
    end,
    hl = { fg = utils.get_highlight("DiagnosticHint").fg },
  },
}

return M
