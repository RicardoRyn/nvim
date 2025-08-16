require("config.options") -- options要写在keymaps前，否则默认<leader>为`\`
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

if not vim.g.vscode then
  require("config.lsp")
  require("config.lsp.lua")
  require("config.lsp.python")
  require("config.lsp.bash")
  require("config.lsp.markdown")

  require("snippets.lua")
  require("snippets.python")
  require("snippets.markdown")

  require("utils.newnotebook")
end
