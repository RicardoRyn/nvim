return {
  "nvim-zh/colorful-winsep.nvim",
  cond = not vim.g.vscode,
  config = true,
  event = { "WinLeave" },
  opts = {
    border = "rounded",
    animate = {
      enabled = false,
    },
  },
}
