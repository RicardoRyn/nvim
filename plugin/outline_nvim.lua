if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("outline").setup()
  end,
  keys = {
    { "n", "<leader>o", "<cmd>Outline<cr>", { desc = "Outline" } },
  },
  cmd = { "Outline" }
})
