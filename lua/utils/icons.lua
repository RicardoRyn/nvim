local M = {}

M.git = {
  added = "󰜄 ",
  modified = "󰏭 ",
  deleted = "󰛲 ",
  renamed = "󰜶 ",
  removed = "󰅘 ",
  ignored = " ",
  tracked = " ",
  untracked = " ",
  staged = "󰱒 ",
  unstaged = "󰄱 ",
  updated = " ",
  conflict = "󱓌 ",
  unmerged = " ",
}

M.diagnostics = {
  error = " ",
  warn = " ",
  warning = " ",
  info = " ",
  hint = " ",
  debug = " ",
  trace = " ",
}

M.comments = {
  fix = " ",
  todo = " ",
  hack = " ",
  warn = " ",
  perf = "󱎫 ",
  test = " ",
  tog = " ",
  note = "󰍨 ",
}

M.lsp = {
  unavailable = "",
  enabled = " ",
  disabled = " ",
  attached = "󰖩 ",
}

M.dap = {
  Stopped = " ",
  BreakpointData = " ",
  BreakpointConditional = " ",
}

return M
