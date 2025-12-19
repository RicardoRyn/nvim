require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

if not vim.g.vscode then
  require("config.lsp")
end
