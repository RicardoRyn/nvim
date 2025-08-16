local lsp_name = "marksman"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")

vim.lsp.config(lsp_name, default_config)
vim.lsp.enable(lsp_name)
