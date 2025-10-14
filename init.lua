require("config.lazy")
require("config.autocmds")
require("config.options")
require("config.keymaps")

if not vim.g.vscode then
  -- LSP
  require("config.lsp")
  require("config.lsp.lua_ls")        -- lua
  require("config.lsp.pyright")       -- python
  require("config.lsp.marksman")      -- markdown
  require("config.lsp.bashls")        -- bash
  require("config.lsp.rust-analyzer") -- rust
end
