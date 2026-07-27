if vim.g.vscode then
  return
end

require("mini.misc").safely("later", function()
  require("mini.cursorword").setup()
end)
