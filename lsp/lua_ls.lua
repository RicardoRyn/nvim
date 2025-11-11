local lsp_name = "lua_ls"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")
local custom_config = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
local final_config = vim.tbl_deep_extend("force", default_config, custom_config) -- 深度合并，保证嵌套

return final_config
