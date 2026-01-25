return {
  "RicardoRyn/ipynb.nvim",
  name = "ipynb.nvim",
  dev = true,
  branch = "main",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    -- "nvim-tree/nvim-web-devicons", -- optional, for language icons
    "folke/snacks.nvim", -- optional, for inline images
  },
  opts = {},
}
