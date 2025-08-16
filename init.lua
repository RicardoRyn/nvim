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

  require("utils.newnotebook")
end

-- TODO: ```python```
-- TODO: markdown中python的格式化，quarto.nvim自带的快捷键
-- TODO: 九头蛇
-- TODO: markdown python pyright诊断信息
-- TODO: kitty烦人的确认框
