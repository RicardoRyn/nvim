return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  main = "nvim-treesitter.configs",
  branch = "master", -- 详见本系列的附录
  event = "VeryLazy",
  opts = {
    ensure_installed = { "lua", "python", "bash", "json", "markdown", "markdown_inline" },
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },
  }
}
