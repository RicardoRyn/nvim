return {
  "esmuellert/vscode-diff.nvim",
  cond = not vim.g.vscode,
  dependencies = { "MunifTanjim/nui.nvim" },
  branch = "next",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "Diff (All)" },
  }
}
