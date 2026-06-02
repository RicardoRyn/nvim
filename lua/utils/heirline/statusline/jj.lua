local colors = require("utils.heirline.colors")
local jj_log = require("utils.jj_log")

-- TODO: 如果只是git仓库而不是jj仓库，则应该显示git branch
local JjLog = {
  condition = jj_log.is_jj_repo,
  provider = function()
    return " " .. jj_log.get()
  end,
  hl = function()
    local color_info = jj_log.get_color()
    if color_info then
      return { fg = color_info.fg, bold = (color_info.gui == "bold") }
    end
    return { fg = colors.gray }
  end,
  update = {
    "User",
    pattern = "JjStatusUpdated",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local Diff = {
  condition = function()
    local s = vim.b.minidiff_summary
    return s ~= nil and s.add ~= nil
  end,
  update = { "User", pattern = "MiniDiffUpdated" },
  init = function(self)
    self.s = vim.b.minidiff_summary
  end,
  {
    provider = function(self)
      return (self.s.add > 0 or self.s.delete > 0 or self.s.change > 0) and " ("
    end,
  },
  {
    provider = function(self)
      return self.s.add > 0 and ("+" .. self.s.add) or ""
    end,
    hl = function()
      return { fg = colors.git_add }
    end,
  },
  {
    provider = function(self)
      return self.s.delete > 0 and ("-" .. self.s.delete) or ""
    end,
    hl = function()
      return { fg = colors.git_del }
    end,
  },
  {
    provider = function(self)
      return self.s.change > 0 and ("~" .. self.s.change) or ""
    end,
    hl = function()
      return { fg = colors.git_change }
    end,
  },
  {
    provider = function(self)
      return (self.s.add > 0 or self.s.delete > 0 or self.s.change > 0) and ")"
    end,
  },
}

local M = {
  JjLog = JjLog,
  Diff = Diff,
}

return M
