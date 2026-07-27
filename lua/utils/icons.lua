local M = {}

M.diff = {
  commit = "󰜘 ",
  staged = "●",
  added = "",
  deleted = "",
  ignored = " ",
  modified = "○",
  renamed = "",
  unmerged = " ",
  untracked = "?",
}

M.diagnostics = {
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

M.comments = {
  fix = " ",
  todo = " ",
  hack = " ",
  warn = " ",
  perf = "󱎫 ",
  test = " ",
  tog = " ",
  setting = " ",
  note = "󰍨 ",
}

M.dap = {
  Stopped = " ",
  BreakpointData = " ",
  BreakpointConditional = " ",
}

return M
