require("config.lazy")
require("config.autocmds")
require("config.options")
require("config.keymaps")

if not vim.g.vscode then
  require("config.lsp")
end
