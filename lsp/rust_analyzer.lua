local lsp_name = "rust_analyzer"
local default_config = dofile(vim.fn.stdpath("data") .. "/site/pack/core/opt/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")

return default_config
