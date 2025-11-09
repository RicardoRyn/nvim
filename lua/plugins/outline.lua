return {
  "hedyhli/outline.nvim",
  cond = not vim.g.vscode,
  cmd = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
  },
  opts = {},
}
