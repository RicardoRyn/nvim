local utils = require("heirline.utils")

local FileIcon = {
  init = function(self)
    local ok, icons = pcall(require, "mini.icons")
    if not ok then
      return
    end
    local icon, hl, _ = icons.get("file", vim.fn.expand("%:t"))
    if icon then
      self.icon = icon
      self.icon_hl = hl
    end
  end,
  condition = function()
    return vim.bo.filetype ~= ""
  end,
  provider = function(self)
    return self.icon and (" " .. self.icon) or ""
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
    return " " .. string.upper(vim.bo.filetype)
  end,
  hl = function(self)
    if not self.icon_hl then
      return
    end
    return { fg = utils.get_highlight(self.hl).fg }
  end,
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= "utf-8" and enc:upper()
  end,
}

local FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= "unix" and fmt:upper()
  end,
}

local FileSize = {
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { "b", "k", "M", "G", "T", "P", "E" }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then
      return fsize .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
  end,
}

local FileLastModified = {
  -- did you know? Vim is full of functions!
  provider = function()
    local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
    return (ftime > 0) and os.date("%c", ftime)
  end,
}

local M = {
  FileIcon = FileIcon,
  FileType = FileType,
  FileEncoding = FileEncoding,
  FileFormat = FileFormat,
  FileSize = FileSize,
  FileLastModified = FileLastModified,
}

return M
