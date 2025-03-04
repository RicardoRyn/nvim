return {
  "nvim-treesitter/nvim-treesitter",
  cond = [[not vim.g.vscode]],

  -- 通过v键和V键来快速框选
  config = function()
    require("nvim-treesitter.configs").setup({
      incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      },
    })
  end,
}
