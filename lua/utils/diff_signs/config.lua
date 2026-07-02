--- @class DiffSigns.Symbols
--- @field add table
--- @field change table
--- @field delete table
--- @field topdelete table

--- @class DiffSigns.Config
--- @field enabled boolean
--- @field style string number | sign
--- @field signs DiffSigns.Symbols
local default_config = {
  enabled = true,
  style = "number",
  signs = {
    add = { icon = "▒", hl = "MiniDiffSignAdd" },
    change = { icon = "▒", hl = "MiniDiffSignChange" },
    delete = { icon = "▒", hl = "MiniDiffSignDelete" },
    topdelete = { icon = "▔", hl = "diffRemoved" },
  },
}

local M = {}

M._config = {} --[[@as table]]

--- Initialize configuration from vim.g.diff_signs if present.  Unspecified
--- data is taken from the default config
M.init = function()
  local user_config = vim.g.diff_signs or {}
  M._config = vim.tbl_deep_extend("force", default_config, user_config)
end

setmetatable(M, {
  --- @param _ table
  --- @param key string
  --- @return any
  __index = function(_, key)
    return M._config[key]
  end,

  --- @param _ table
  --- @param key string
  --- @param value any
  --- @return any
  __newindex = function(_, key, value)
    M._config[key] = value
  end,
})

return M
