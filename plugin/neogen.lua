if vim.g.vscode then return end

require("utils.lazy").safely({
  setup = function()
    require("neogen").setup({
      enable = true,
      snippet_engine = "luasnip",
      languages = {
        python = require("neogen.python"),
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { "n", "<leader>lN", function() require("neogen").generate() end, { desc = "Generate docstring" } },
  },
})
