local lsp_name = "matlab_ls"
local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")

return default_config
