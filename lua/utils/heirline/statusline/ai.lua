local colors = require("utils.heirline.colors")

local M = {
  condition = function()
    return #require("sidekick.status").cli() > 0
  end,
  provider = function()
    local status = require("sidekick.status").cli()
    return " " .. (#status > 1 and #status or "") .. " "
  end,
  hl = function()
    return { fg = colors.cyan }
  end,
}

return M
