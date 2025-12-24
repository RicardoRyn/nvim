return {
  dir = "E:/git_repositories/colorful-winsep.nvim",
  name = "colorful-winsep-dev",
  config = function ()
    require("colorful-winsep").setup({
      highlight = "green",
    })
    vim.keymap.set("n", "<leader>R", "<cmd>Lazy reload colorful-winsep-dev<cr>", { desc = "Reload Plugin (colorful-winsep)" })
  end
}
