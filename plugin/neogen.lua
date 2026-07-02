if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    dd("Neogen setup")
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
    { "n", "<leader>ln", function() require("neogen").generate() end, { desc = "Generate docstring" } },
  },
})
