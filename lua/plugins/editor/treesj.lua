return {
  'Wansmer/treesj',
  keys = { "<leader>lm" },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<leader>lm", require("treesj").toggle, { desc = "Toggle Code Block" })
  end,
}
