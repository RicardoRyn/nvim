local conditions = require("heirline.conditions")
local colors = require("utils.heirline.colors")
local utils = require("heirline.utils")

local FileName = {
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":t")
    if filename == "" then
      return "[No Name] "
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename .. " "
  end,
}

local FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = "[+] ",
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = "  ",
  },
}

local FileNameModifer = {
  hl = function(self)
    return { fg = colors.background, bg = self.current_bg, bold = true, force = true }
  end,
}

local WrappedComponent = utils.surround({ "", "" }, function(self)
  return self.current_bg
end, utils.insert(FileNameModifer, FileName, FileFlags, { provider = "%<" }))

local M = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    if vim.bo.modified then
      self.current_bg = colors.orange
    else
      self.current_bg = colors.blue
    end
    vim.g.heirline_file_bg = self.current_bg
  end,
  WrappedComponent,
}

return M
