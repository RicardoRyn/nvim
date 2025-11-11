local lsp_name = "bashls"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")

return default_config
