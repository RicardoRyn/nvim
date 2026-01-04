return {
  "danymat/neogen",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<leader>D", function() require("neogen").generate() end, desc = "Generate docstring" },
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      snippet_engine = "luasnip",
    })
  end,
}

