return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  cond = not vim.g.vscode,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
}
