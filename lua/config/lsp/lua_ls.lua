local lsp_name = "lua_ls"

local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")
local custom_config = {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = require("lspconfig.util").root_pattern(
      ".git",
      "init.lua",
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml"
    )(fname) or vim.fn.getcwd()
    on_dir(root)
  end,
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

vim.lsp.config(lsp_name, final_config)
vim.lsp.enable(lsp_name)
