if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  local icons = require("mini.icons")
  icons.setup()
  icons.tweak_lsp_kind()
end)
