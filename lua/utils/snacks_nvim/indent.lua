local M = {
  enabled = true,
  indent = {
    char = "▏",
    hl = {
      "DiagnosticError", -- red
      "String", -- green
      "Function", -- blue
      "Special", -- pink
      "Constant", -- orange
      "Statement", -- purple
      "Type", -- yellow
    },
  },
  scope = { char = "▍", hl = "" },
}

return M
