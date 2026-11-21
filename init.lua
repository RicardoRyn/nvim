if not vim.g.vscode then
  vim.loader.enable()
  require("vim._core.ui2").enable({
    enable = true,
    msg = {
      targets = "msg",
      msg = {
        timeout = 3000,
      },
    },
  })
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.pack")
require("config.lsp")

require("dev")
