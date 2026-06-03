local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local FileType = require("utils.heirline.statusline.file_others").FileType
local TerminalName = require("utils.heirline.statusline.terminal_name")
local FileNameBlock = require("utils.heirline.statusline.file_name_block")
local Space = { provider = " " }

local M = {
  fallthrough = false,
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    utils.surround({ "", "" }, "dark_red", {
      FileType,
      Space,
      TerminalName,
    }),
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, FileNameBlock }),
  },
  -- A winbar for regular files
  utils.surround({ "", "" }, "bright_bg", FileNameBlock),
}
return M
