return {
  "MeanderingProgrammer/render-markdown.nvim",
  cond = not vim.g.vscode,
  ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
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
      highlight_inline = "rendermarkdowncodeinfo", -- 避免标题中出现其他背景色
    },
    heading = {
      sign = false,
      icons = {},
      border = true,
      render_modes = true,
    },
    anti_conceal = {
      enabled = true,
      disabled_modes = { "n" },
    },
    latex = { enabled = false },
  },
}
