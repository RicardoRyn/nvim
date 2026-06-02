local colors = require("utils.heirline.colors")

local M = {
  condition = function()
    return require("lazy.status").has_updates()
  end,
  provider = function()
    return require("lazy.status").updates() .. " "
  end,
  hl = function()
    return { fg = colors.cyan }
  end,
}

return M
