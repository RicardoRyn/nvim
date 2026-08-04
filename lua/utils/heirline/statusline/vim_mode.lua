local colors = require("utils.heirline.colors")

vim.g.heirline_vimode_bg = colors.blue

local VimModeCore = {
  provider = function(self)
    return " " .. self.mode_names[self.mode] .. " "
  end,
  hl = function(self)
    return { fg = colors.background, bg = self.mode_color(self.mode), bold = true }
  end,
}

local M = {
  init = function(self)
    self.mode = vim.fn.mode(1)
    vim.g.heirline_vimode_bg = self.mode_color(self.mode)
  end,
  static = {
    -- mode_names = {
    --   n = "NORMAL",
    --   no = "O-PENDING",
    --   nov = "O-PENDING",
    --   noV = "O-PENDING",
    --   ["no\22"] = "O-PENDING",
    --   niI = "NORMAL",
    --   niR = "NORMAL",
    --   niV = "NORMAL",
    --   nt = "NORMAL",
    --   v = "VISUAL",
    --   vs = "VISUAL",
    --   V = "V-LINE",
    --   Vs = "V-LINE",
    --   ["\22"] = "V-BLOCK",
    --   ["\22s"] = "V-BLOCK",
    --   s = "SELECT",
    --   S = "S-LINE",
    --   ["\19"] = "S-BLOCK",
    --   i = "INSERT",
    --   ic = "INSERT",
    --   ix = "INSERT",
    --   R = "REPLACE",
    --   Rc = "REPLACE",
    --   Rx = "REPLACE",
    --   Rv = "V-REPLACE",
    --   Rvc = "V-REPLACE",
    --   Rvx = "V-REPLACE",
    --   c = "COMMAND",
    --   cv = "EX",
    --   r = "REPLACE",
    --   rm = "MORE",
    --   ["r?"] = "CONFIRM",
    --   ["!"] = "SHELL",
    --   t = "TERMINAL",
    -- },
    mode_names = {
      n = "N", -- NORMAL
      no = "OP",
      nov = "OP",
      noV = "OP",
      ["no\22"] = "OP",
      niI = "N",
      niR = "N",
      niV = "N",
      nt = "N",
      v = "V", -- VISUAL
      vs = "V",
      V = "VL", -- VISUAL LINE
      Vs = "VL",
      ["\22"] = "VB", -- VISUAL BLOCK
      ["\22s"] = "VB",
      s = "S", -- SELECT
      S = "SL", -- SELECT LINE
      ["\19"] = "SB", -- SELECT BLOCK
      i = "I", -- INSERT
      ic = "I",
      ix = "I",
      R = "R", -- REPLACE
      Rc = "R",
      Rx = "R",
      Rv = "VR", -- V-REPLACE
      Rvc = "VR",
      Rvx = "VR",
      c = "C", -- COMMAND
      cv = "EX", -- EX (保持原样)
      r = "R", -- 单字符替换提示（仍用 "R"）
      rm = "MORE",
      ["r?"] = "CONF",
      ["!"] = "SH",
      t = "T", -- TERMINAL
    },
    mode_color = function(mode)
      return ({
        n = colors.blue,
        no = colors.yellow,
        nt = colors.blue,
        i = colors.green,
        ic = colors.green,
        v = colors.purple,
        V = colors.purple,
        ["\22"] = colors.purple,
        c = colors.orange,
        s = colors.purple,
        S = colors.purple,
        ["\19"] = colors.purple,
        R = colors.yellow,
        Rv = colors.yellow,
        Rvc = colors.yellow,
        r = colors.yellow,
        ["!"] = colors.green,
        t = colors.red,
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
  VimModeCore,
}

return M
