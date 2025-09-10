return {
  "MeanderingProgrammer/render-markdown.nvim",
  cond = not vim.g.vscode,
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    code = {
      sign = false,
      width = "block",
      min_width = 80,
      right_pad = 1,
      border = "thin",
      position = "right",
      -- 避免标题中出现其他背景色
      highlight_inline = "RenderMarkdownCodeInfo",
    },
    heading = {
      sign = false,
      icons = {},
      border = true,
      render_modes = true,
    },
    anti_conceal = {
      disabled_modes = true,
      ignore = {
        head_border = true,
        head_background = true,
      },
    },
  },
}
