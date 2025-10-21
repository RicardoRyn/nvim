return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local wanted = {
      "lua",
      "python",
      "bash",
      "rust",
      "json",
      "markdown",
      "markdown_inline",
    }
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install(wanted)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = wanted,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
