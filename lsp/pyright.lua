local lsp_name = "pyright"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")

return default_config
