local conditions = require("heirline.conditions")
local colors = require("utils.heirline.colors")

local WorkDir = {
  provider = function()
    local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#cwd, 0.25) then
      cwd = vim.fn.pathshorten(cwd)
    end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = function()
    return { fg = colors.blue, bold = true }
  end,
}

local FlexWorkDir = {
  init = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ":~")
  end,
  hl = function()
    return { fg = colors.blue, bold = true }
  end,

  flexible = 1,

  {
    -- evaluates to the full-lenth path
    provider = function(self)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. self.cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to the shortened path
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == "/" and "" or "/"
      return self.icon .. cwd .. trail .. " "
    end,
  },
  {
    -- evaluates to "", hiding the component
    provider = "",
  },
}

local CurrentDir = {
  provider = function()
    return "  " .. vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:h")
  end,
  hl = function()
    return { fg = vim.g.heirline_file_bg }
  end,
}

local M = {
  WorkDir1 = WorkDir,
  WorkDir2 = FlexWorkDir,
  CurrentDir = CurrentDir,
}

return M
