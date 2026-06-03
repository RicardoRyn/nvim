local utils = require("heirline.utils")

local Tabpage = {
  provider = function(self)
    return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
  end,
  hl = function(self)
    if not self.is_active then
      return { fg = utils.get_highlight("TabLine").fg }
    else
      return { fg = utils.get_highlight("TabLineSel").fg }
    end
  end,
}

local TabpageClose = {
  provider = "%999X  %X",
  hl = function()
    return { fg = utils.get_highlight("TabLine").fg }
  end,
}

local M = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = "%=" },
  utils.make_tablist(Tabpage),
  TabpageClose,
}

return M
