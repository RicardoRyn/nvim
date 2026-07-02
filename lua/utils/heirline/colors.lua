local utils = require("heirline.utils")

local M = {}

local function get_colors()
  return {
    background = utils.get_highlight("Normal").bg,
    bright_bg = utils.get_highlight("Folded").bg,
    bright_fg = utils.get_highlight("Folded").fg,
    red = utils.get_highlight("DiagnosticError").fg,
    green = utils.get_highlight("String").fg,
    blue = utils.get_highlight("Function").fg,
    gray = utils.get_highlight("NonText").fg,
    orange = utils.get_highlight("Constant").fg,
    yellow = utils.get_highlight("Type").fg,
    purple = utils.get_highlight("Statement").fg,
    cyan = utils.get_highlight("Special").fg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    git_add = utils.get_highlight("MiniDiffSignAdd").fg,
    git_change = utils.get_highlight("MiniDiffSignChange").fg,
    git_del = utils.get_highlight("MiniDiffSignDelete").fg,
  }
end

local function setup_colors()
  for name, color in pairs(get_colors()) do
    M[name] = color
  end

  return M
end

setup_colors()

local augroup = vim.api.nvim_create_augroup("SetupHeirlineColors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
    vim.cmd.redrawstatus()
  end,
  group = augroup,
})

return M
