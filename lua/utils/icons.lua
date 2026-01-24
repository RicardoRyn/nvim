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

M.kind = {
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

return M
