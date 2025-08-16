return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  cond = function()
    return vim.loop.os_uname().sysname == "Linux" and not vim.g.vscode
  end,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
}
