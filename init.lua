if not _G.SYSTEM then
  _G.SYSTEM = require("utils.system")
end

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("utils.debug")

if not vim.g.vscode then
  require("config.lsp")
end
