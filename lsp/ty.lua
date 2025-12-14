local lsp_name = "ty"
local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")
local custom_config = {
  settings = {
    python = {
      analysis = {
        -- 类型检查模式: "off", "basic", "standard", "strict"
        typeCheckingMode = "standard",
        -- 自动搜索路径
        autoSearchPaths = true,
        -- 使用库代码进行类型检查
        useLibraryCodeForTypes = true,
        -- 诊断模式: "openFilesOnly", "workspace"
        diagnosticMode = "openFilesOnly",
        -- 自动导入补全
        autoImportCompletions = true,
      },
    },
  },
}
local final_config = vim.tbl_deep_extend("force", default_config, custom_config)

return final_config
