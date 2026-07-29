local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")

local function save_names()
  local tabs = vim.api.nvim_list_tabpages()
  local names = {}
  for i, handle in ipairs(tabs) do
    local name = vim.t[handle].tab_name
    if name then
      names[tostring(i)] = name
    end
  end
  vim.g.TabNames = vim.json.encode(names)
end

local function restore_names()
  local raw = vim.g.TabNames
  if not raw then return end
  local ok, names = pcall(vim.json.decode, raw)
  if not ok or type(names) ~= "table" then return end
  local tabs = vim.api.nvim_list_tabpages()
  for i_str, name in pairs(names) do
    local i = tonumber(i_str)
    if i and tabs[i] then
      vim.t[tabs[i]].tab_name = name
    end
  end
end

local Tabpage = {
  provider = function(self)
    local handles = vim.api.nvim_list_tabpages()
    local handle = handles[self.tabnr]
    local name = handle and vim.t[handle].tab_name or nil
    local label = name and (self.tabnr .. ": " .. name) or tostring(self.tabnr)
    return "%" .. self.tabnr .. "T " .. label .. " %T"
  end,
  hl = function(self)
    if not self.is_active then
      if #vim.api.nvim_list_tabpages() <= 1 then
        return { fg = colors.background, bg = colors.blue }
      else
        return { fg = utils.get_highlight("TabLine").fg }
      end
    else
      return { fg = colors.background, bg = colors.blue }
    end
  end,
}

local TabpageClose = {
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  provider = "%999X  %X",
  hl = function()
    return { fg = utils.get_highlight("TabLine").fg }
  end,
}

local M = {
  utils.make_tablist(Tabpage),
  TabpageClose,
}

local augroup = vim.api.nvim_create_augroup("TabNamePersist", { clear = true })

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup,
  callback = save_names,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
  group = augroup,
  callback = restore_names,
})

vim.keymap.set("n", "<leader>tr", function()
  local name = vim.fn.input("Tab rename: ")
  if name == "" then
    vim.t.tab_name = nil
  else
    vim.t.tab_name = name
  end
  save_names()
end, { desc = "Tab rename" })

return M
