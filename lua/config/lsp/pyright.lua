local lsp_name = "pyright"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")
local custom_config = {
  settings = {
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportUnusedExpression = "none", -- 在ipynb中最后一行写一个变量，将其打印出来很正常
        },
      },
    },
  },
}
local final_config = vim.tbl_deep_extend("force", default_config, custom_config) -- 深度合并，保证嵌套

vim.lsp.config(lsp_name, final_config)
vim.lsp.enable(lsp_name)
