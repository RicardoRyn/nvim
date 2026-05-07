return {
  "NStefan002/screenkey.nvim",
  cond = not vim.g.vscode,
  cmd = {"Screenkey"},
  version = "*", -- or branch = "main", to use the latest commit
  opts = {
    win_opts = {
      row = vim.o.lines - vim.o.cmdheight - 1,
      col = vim.o.columns - 60,
    },
  },
}
