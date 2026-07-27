if vim.g.vscode then
  return
end

require("mini.misc").safely("later", function()
  require("mini.animate").setup({
    cursor = { enable = false },
    resize = { enable = false },
  })
end)
