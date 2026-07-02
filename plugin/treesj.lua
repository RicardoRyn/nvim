require("utils.lazy").load({
  setup = function()
    require("treesj").setup({
      use_default_keymaps = false,
    })
  end,
  keys = {
    { "n", "<leader>lm", require("treesj").toggle, { desc = "LSP toggle code block" } }
  },
})
