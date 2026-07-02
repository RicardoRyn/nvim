if not vim.g.vscode then
  require("vim._core.ui2").enable({})
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.pack")

require("utils.diff_signs")

require("dev")
