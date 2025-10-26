-- -- FIX: main分支的nvim-treesitter无法自动加载
-- return {
--   "nvim-treesitter/nvim-treesitter",
--   cond = not vim.g.vscode,
--   lazy = false,
--   branch = "main",
--   build = ":TSUpdate",
--   config = function()
--     local wanted = {
--       "lua",
--       "python",
--       "bash",
--       "rust",
--       "json",
--       "markdown",
--       "markdown_inline",
--       "latex",
--       "html",
--       "yaml",
--     }
--     require("nvim-treesitter").setup({})
--     require("nvim-treesitter").install(wanted)
--
--     vim.api.nvim_create_autocmd("FileType", {
--       pattern = wanted,
--       callback = function() vim.treesitter.start() end, }) end,
-- }

return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  main = "nvim-treesitter.configs",
  branch = "master", -- 详见本系列的附录
  event = "VeryLazy",
  opts = {
    ensure_installed = {
      "lua",
      "python",
      "bash",
      "rust",
      "json",
      "markdown",
      "markdown_inline",
      -- "latex",
      "html",
      "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },
  },
}
