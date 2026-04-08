return {
  "aurora0x27/popup.nvim",
  event = { "UIEnter" },
  cond = not vim.g.vscode,
  init = function()
    vim.opt.cmdheight = 0
  end,
  opts = {},
}
