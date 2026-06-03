local utils = require("heirline.utils")

local FileIcon = {
  init = function(self)
    local filename = self.filename
    self.icon, self.hl, _ = require("mini.icons").get("file", filename)
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon .. " ") or ""
  end,
  hl = function(self)
    if not self.icon_hl then
      return
    end
    return { fg = utils.get_highlight(self.icon_hl).fg }
  end,
}

local FileType = {
  init = function(self)
    local ok, icons = pcall(require, "mini.icons")
    if not ok then
      return
    end
    local _, hl, _ = icons.get("file", vim.fn.expand("%:t"))
    if hl then
      self.hl = hl
    end
  end,
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = function(self)
    if not self.icon_hl then
      return
    end
    return { fg = utils.get_highlight(self.hl).fg }
  end,
}

local M = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

function M.get_fileicon()
  return FileIcon
end

M = utils.insert(M, FileIcon, FileType)

return M
