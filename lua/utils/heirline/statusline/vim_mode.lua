local colors = require("utils.heirline.colors")
local utils = require("heirline.utils")

vim.g.heirline_vimode_bg = colors.blue

local VimModeCore = {
  provider = function(self)
    return self.mode_names[self.mode] .. " "
  end,
  hl = function(self)
    return { fg = colors.background, bg = self.mode_color(self.mode), bold = true }
  end,
}

local WrappedVimModeCore = utils.surround({ "", "" }, function(self)
  return self.mode_color(self.mode)
end, VimModeCore)

local M = {
  init = function(self)
    self.mode = vim.fn.mode(1)
    vim.g.heirline_vimode_bg = self.mode_color(self.mode)
  end,
  static = {
    mode_names = {
      n = "NORMAL",
      no = "O-PENDING",
      nov = "O-PENDING",
      noV = "O-PENDING",
      ["no\22"] = "O-PENDING",
      niI = "NORMAL",
      niR = "NORMAL",
      niV = "NORMAL",
      nt = "NORMAL",
      v = "VISUAL",
      vs = "VISUAL",
      V = "V-LINE",
      Vs = "V-LINE",
      ["\22"] = "V-BLOCK",
      ["\22s"] = "V-BLOCK",
      s = "SELECT",
      S = "S-LINE",
      ["\19"] = "S-BLOCK",
      i = "INSERT",
      ic = "INSERT",
      ix = "INSERT",
      R = "REPLACE",
      Rc = "REPLACE",
      Rx = "REPLACE",
      Rv = "V-REPLACE",
      Rvc = "V-REPLACE",
      Rvx = "V-REPLACE",
      c = "COMMAND",
      cv = "EX",
      r = "REPLACE",
      rm = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      t = "TERMINAL",
    },
    mode_color = function(mode)
      return ({
        n = colors.blue,
        nt = colors.blue,
        i = colors.green,
        v = colors.purple,
        V = colors.purple,
        ["\22"] = colors.purple,
        c = colors.orange,
        s = colors.purple,
        S = colors.purple,
        ["\19"] = colors.purple,
        R = colors.red,
        r = colors.red,
        ["!"] = colors.green,
        t = colors.green,
      })[mode]
    end,
  },
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
  WrappedVimModeCore,
}

return M
