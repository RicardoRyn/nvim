return {
  "danymat/neogen",
  event = "VeryLazy",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<leader>d", function() require("neogen").generate() end, desc = "Generate docstring" },
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      snippet_engine = "luasnip",
    })
  end,
}

