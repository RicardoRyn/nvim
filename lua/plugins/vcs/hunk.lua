return {
  "julienvincent/hunk.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  branch = "jv/3-way-merge-tool",
  cond = not vim.g.vscode,
  cmd = { "DiffEditor", "MergeEditor" },
  opts = {},
}
