require("utils.lazy").load({
  setup = function()
    require("diffbandit").setup()
    end,
  keys = {
    { "n", "<leader>gd", "<cmd>DiffBanditGit<cr>", {desc = "Toggle DiffBandit" } },
  },
})

