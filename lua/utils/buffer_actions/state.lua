local M = {
  ---@type table<number, number[]>  tab handle -> buffer list
  tab_buffers = {},

  ---@type table<number, boolean>  pinned[bufnr] = true
  pinned = {},

  pick_labels = {},

  is_picking = false,
}

return M
