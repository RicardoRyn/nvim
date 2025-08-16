return {
  "MeanderingProgrammer/render-markdown.nvim",
  cond = function()
    return vim.loop.os_uname().sysname == "Linux" and not vim.g.vscode
  end,
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    code = {
      width = "block",
      right_pad = 1,
      border = "thin",
    },
    heading = {
      icons = {},
    },
  },
}
