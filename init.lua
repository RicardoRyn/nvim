-- lazy需要首先加载，因为里面定义了<leader>与<localleader>
require("config.lazy")
require("config.autocmds")
require("config.options")
require("config.keymaps")

if not vim.g.vscode then
  -- LSP
  require("config.lsp")
  require("config.lsp.lua_ls") -- lua
  require("config.lsp.pyright") -- python
  require("config.lsp.marksman") -- markdown
  require("config.lsp.bashls") -- bash
  require("config.lsp.rust-analyzer") -- rust
  -- Utils
  require("utils.newnotebook")
end

-- NOTE: neovim中的技巧
-- `echo &filetype`可以查看当前文件类型
