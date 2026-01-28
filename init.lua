-- Load system utils
if not _G.SYSTEM then
  _G.SYSTEM = require("utils.system")
end

require("utils.debug")
require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")

if not vim.g.vscode then
  require("config.lsp")
end
