return {
  "danymat/neogen",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    {
      "<leader>ln",
      function()
        require("neogen").generate()
      end,
      desc = "Generate docstring",
    },
  },
  config = function()
    require("neogen").setup({
      enable = true,
      snippet_engine = "luasnip",
      languages = {
        python = require("neogen.python"),
      },
    })
  end,
}
