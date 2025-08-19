return {
  "nvim-zh/colorful-winsep.nvim",
  cond = function()
    return not vim.g.vscode
  end,
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
