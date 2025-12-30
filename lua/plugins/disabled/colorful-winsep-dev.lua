return {
  dir = "~/git_repositories/colorful-winsep.nvim",
  name = "colorful-winsep",
  config = function()
    require("colorful-winsep").setup({

    })
    vim.keymap.set("n", "<leader>R", "<cmd>Lazy reload colorful-winsep<cr>", { desc = "Reload Dev Plugin" })
  end,
}
