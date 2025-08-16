if vim.g.vscode then
  return {}
else
  return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    cond = function()
      return vim.loop.os_uname().sysname == "Linux"
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
  }
end
