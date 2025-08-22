local icons = {}

icons.git = {
  modified = "󰏭 ",
  added = "󰜄 ",
  deleted = "󰛲 ",
  removed = "󰛲 ",
  ignored = "󰅘 ",

  untracked = "󰄱 ",
  unstaged = "󰄱 ",
  tracked = "󰱒 ",
  staged = "󰱒 ",

  renamed = "󰜶 ",
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

-- 从LzayVim中抄的，不知道有啥用
icons.kinds = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Codeium = "󰘦 ",
  Color = " ",
  Control = " ",
  Collapsed = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = "󱄽 ",
  String = " ",
  Struct = "󰆼 ",
  Supermaven = " ",
  TabNine = "󰏚 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰀫 ",
}

return icons
