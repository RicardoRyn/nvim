return {
  'Wansmer/treesj',
  cond = not vim.g.vscode,
  keys = { '<space>m' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
    vim.keymap.set("n", "<leader>m", require("treesj").toggle, { desc = "Toggle Code Block" })
  end,
}
