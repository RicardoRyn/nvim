local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")

-- We're getting minimalist here!
local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "[%l/%2L:%2c %P] ",
}

local ScrollBar = {
  static = {
    sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2) .. " "
  end,
  hl = function()
    return { fg = vim.g.heirline_vimode_bg or colors.blue, bg = utils.get_highlight("StatusLine").bg }
  end,
}

local M = {
  Ruler = Ruler,
  ScrollBar = ScrollBar,
}

return M
