if vim.g.vscode then return end

require("utils.lazy").register({
  setup = function()
    require("config.completion").ensure_snippets()
    require("neogen").setup({
      enable = true,
      snippet_engine = "mini",
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
