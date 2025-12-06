-- 需要：cargo install --locked tree-sitter-cli
return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  lazy = false,
  branch = "main",
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
      "latex",
      "html",
      "yaml",
    }
    require("nvim-treesitter").setup({})
    require("nvim-treesitter").install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function() vim.treesitter.start() end, })
    end,
}
