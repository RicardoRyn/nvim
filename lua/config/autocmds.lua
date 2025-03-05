-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

if not vim.g.vscode then
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("associate_filetype"),
    pattern = { "python" },
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.formatoptions:remove({ "o" }) -- 防止使用 o 切换到下一行的时候自动加上注释符号(在上一行是注释的情况下)
      vim.opt_local.spell = false
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("associate_filetype"),
    pattern = { "sh", "lua" },
    callback = function()
      vim.opt.shiftwidth = 2
      vim.opt.formatoptions:remove({ "o" }) -- 防止使用 o 切换到下一行的时候自动加上注释符号(在上一行是注释的情况下)
      vim.opt_local.spell = false
    end,
  })
else
  -- vscode中必须单独写出来才生效 = =+
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup("associate_filetype"),
    pattern = { "python" },
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.formatoptions:remove({ "o" }) -- 防止使用 o 切换到下一行的时候自动加上注释符号(在上一行是注释的情况下)
      vim.opt_local.spell = false
    end,
  })
end
