local colors = require("utils.heirline.colors")

local M = {
  condition = function()
    return vim.bo.filetype == "help"
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
  end,
  hl = function()
    return { fg = colors.blue }
  end,
}

return M
