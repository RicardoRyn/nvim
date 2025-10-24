local icons = {}

icons.git = {
  added = "󰜄 ",
  modified = "󰏭 ",
  deleted = "󰛲 ",
  renamed = "󰜶 ",

  removed = "󰅘 ",
  ignored = " ",

  untracked = " ",
  unstaged = "󰄱 ",
  tracked = " ",
  staged = "󰱒 ",

  conflict = " ",
  updated = " ",
}

icons.diagnostics = {
  error = " ",
  warn = " ",
  warning = " ",
  info = " ",
  hint = " ",
  debug = " ",
  trace = " ",
}

icons.comments = {
  fix = " ",
  todo = " ",
  hack = " ",
  warn = " ",
  perf = "󱎫 ",
  test = " ",
  note = "󰍨 ",
}

icons.dap = {
  Stopped = "󰁕 ",
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = " ",
  LogPoint = ".>",
}

return icons
