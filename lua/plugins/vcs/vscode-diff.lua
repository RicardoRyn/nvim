-- FIX: merge中有bug，会导致增加的部分消失
return {
  "esmuellert/vscode-diff.nvim",
  enabled = false,
  cond = not vim.g.vscode,
  dependencies = { "MunifTanjim/nui.nvim" },
  branch = "next",
  cmd = "CodeDiff",
  keys = {
    { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "Diff (All)" },
  }
}
