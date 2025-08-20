return {
  "jiaoshijie/undotree",
  cond = not vim.g.vscode,
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = { -- load the plugin only when using it's keybinding:
    { "<leader>cu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undotree" },
  },
}
