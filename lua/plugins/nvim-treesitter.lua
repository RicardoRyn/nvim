return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local languages = {
      "lua",
      "python",
      "bash",
      "rust",
      "json",
      "markdown",
      "markdown_inline",
      "css",
      "html",
      "javascript",
      "latex",
      "scss",
      "svelte",
      "tsx",
      "typst",
      "vue",
      "norg",
    }
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
