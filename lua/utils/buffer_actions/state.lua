local M = {}

M.state = {
  ---@type number[]
  buffer_order = {},

  ---@type table<number, boolean>  pinned[bufnr] = true
  pinned = {},

  pick_labels = {},

  is_picking = false,
}

return M
