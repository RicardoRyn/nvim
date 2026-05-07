return {
  "julienvincent/hunk.nvim",
  branch = "jv/3-way-merge-tool",
  cond = not vim.g.vscode,
  cmd = { "DiffEditor", "MergeEditor" },
  opts = {}
}
