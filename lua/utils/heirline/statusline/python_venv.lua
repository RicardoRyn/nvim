local colors = require("utils.heirline.colors")

local M = {}

M = {
  condition = function()
    return vim.bo.filetype == "python"
  end,

  init = function(self)
    local ok, vs = pcall(require, "venv-selector")
    if not ok then
      self.source = nil
      self.python = nil
      self.workspace_path = nil
      return
    end

    self.source = vs.source()
    self.python = vs.python()
    local paths = vs.workspace_paths()
    self.workspace_path = paths and paths[1] or nil
  end,

  provider = function(self)
    if self.python ~= nil and self.python ~= "" then
      local parts = vim.split(vim.fs.normalize(self.python), "/")
      if self.source == "workspace" or self.source == "cwd" then
        local name = parts[#parts - 3]
        return " " .. name .. " "
      elseif self.source == "anaconda_base" then
        local name = parts[#parts - 1]
        return " " .. name .. " "
      end
      return " " .. self.source .. " " or ""
    end
    return ""
  end,

  hl = function(self)
    if self.source == "workspace" or self.source == "cwd" then
      return { fg = colors.yellow }
    elseif self.source == "anaconda_base" then
      return { fg = colors.green }
    end
  end,
}

return M
