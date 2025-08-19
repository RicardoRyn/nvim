-- lazy需要首先加载，因为里面定义了<leader>与<localleader>
require("config.lazy")
require("config.autocmds")
require("config.options")
require("config.keymaps")

if not vim.g.vscode then
  require("config.lsp")
  require("config.lsp.lua")
  require("config.lsp.python")
  require("config.lsp.markdown")
  require("config.lsp.bash")

  require("snippets.lua")
  require("snippets.python")
  require("snippets.markdown")

  require("utils.newnotebook")
end

-- TODO: 怎么在ipynb中折叠一个cell，但是显示其是否在运行的虚拟文字
