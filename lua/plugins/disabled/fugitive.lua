return {
  "tpope/vim-fugitive",
  enabled = false,
  cond = not vim.g.vscode,
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>gs", "<cmd>G<cr>", { desc = "Status", silent = true })
  end,
}
