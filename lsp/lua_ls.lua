local lsp_name = "lua_ls"
local default_config = dofile(vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lsp/" .. lsp_name .. ".lua")
local custom_config = {
  -- HACK: 不写下面一段，会加载大量文件，耗尽内存
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
      runtime = {
        version = "LuaJIT", -- Neovim 使用 LuaJIT
      },
      diagnostics = {
        globals = { "vim", "Snacks" },
      },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
        checkThirdParty = false,
      },
      telemetry = {
        enable = false, -- 关闭遥测
      },
       format = {
         enable = false,
       },
    },
  },
}
local final_config = vim.tbl_deep_extend("force", default_config, custom_config)

return final_config
