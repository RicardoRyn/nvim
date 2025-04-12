-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

if not vim.g.vscode then
  -- nvim中的配置
  -- nvim中的配置
  -- nvim中的配置
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = false
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.formatoptions:remove({ "o" })
      vim.opt_local.spell = false
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "lua", "nu" },
    callback = function()
      vim.opt.shiftwidth = 2
      vim.opt.formatoptions:remove({ "o" })
      vim.opt_local.spell = false
    end,
  })

  require("lspconfig").pyright.setup({
    settings = {
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
      python ={
        analysis = {
          -- Ignore all files for analysis to exclusively use Ruff for linting
          ignore = { "*" }
        }
      }
    }
  })

else
  -- vscode中必须单独写出来才生效 = =+
  -- vscode中必须单独写出来才生效 = =+
  -- vscode中必须单独写出来才生效 = =+
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
      vim.opt.shiftwidth = 4
      vim.opt.formatoptions:remove({ "o" })
      vim.opt_local.spell = false
    end,
  })
end
