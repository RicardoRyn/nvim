local icons = {}

icons.git = {
  modified  = "",
  added     = "",
  ignored   = "",
  deleted   = "",

  untracked = "",
  unstaged  = "",
  staged    = "",
  tracked   = "",

  renamed   = "➜",
  conflict  = "",
  updated   = "󰚰",
}

icons.diagnostics = {
  error   = "",
  warning = "",
  warn = "",
  info    = "",
  hint    = "",
}

icons.comments = {
  fix   = "",
  todo = "",
  hack = "󰈸",
  warn = "",
  perf = "󰅒",
  test = "󰙨",
  note = "󰍨",
}

return icons
