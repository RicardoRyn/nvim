return {
  "s1n7ax/nvim-window-picker",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  name = "window-picker",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      hint = "floating-big-letter",
    })
  end,
}
