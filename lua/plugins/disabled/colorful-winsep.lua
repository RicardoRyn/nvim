return {
  "nvim-zh/colorful-winsep.nvim",
  cond = not vim.g.vscode,
  event = { "WinLeave" },
  opts = {
    border = "rounded",
    animate = {
      enabled = false,
    },
  },
}
