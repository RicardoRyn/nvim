if vim.g.vscode then
  return
end

if not require("utils.system").is_mac then
  return
end

require("utils.lazy").safely({
  setup = function()
    require("kitty-scrollback").setup()
  end,
})
