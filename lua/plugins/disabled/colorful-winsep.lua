return {
  "nvim-zh/colorful-winsep.nvim",
  cond = not vim.g.vscode,
  config = true,
  event = { "WinLeave" },
  opts = {
    border = "rounded",
    highlight = "#1e66f5",
    animate = {
      enabled = "false"
    }
  },
}
