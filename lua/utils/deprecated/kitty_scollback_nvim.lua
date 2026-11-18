if vim.g.vscode then
  return
end

if not require("utils.system").is_mac then
  return
end

require("mini.misc").safely("later", function()
  require("kitty-scrollback").setup()
end)
