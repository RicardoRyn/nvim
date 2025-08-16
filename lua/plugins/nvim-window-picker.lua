return {
  "s1n7ax/nvim-window-picker",
  cond = function()
    return not vim.g.vscode
  end,
  name = "window-picker",
  event = "VeryLazy",
  version = "2.*",
  config = function()
    require("window-picker").setup({
      hint = "floating-big-letter",
    })
  end,
}
