if vim.g.vscode then
  return
end

require("utils.lazy").safely({
  setup = function()
    require("screenkey").setup({
      win_opts = {
        row = vim.o.lines - vim.o.cmdheight - 1,
        col = vim.o.columns - 60,
      },
    })
  end,
  keys = {
    { "n", "<leader>us", "<cmd>Screenkey<cr>", { desc = "Toggle screenkey" } },
  },
})
