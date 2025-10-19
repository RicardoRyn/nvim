return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "bash",
      "rust",
      "markdown",
      "markdown_inline",
      "yaml",
    },
    auto_install = true,
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  },
}
