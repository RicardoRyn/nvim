return {
  "nvim-mini/mini.diff",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  version = false,
  opts = {
    view = {
      style = "sign",
    },
    mappings = {
      textobject = "ih",
    },
  },
  config = function(_, opts)
    require("mini.diff").setup(opts)
    vim.keymap.set({ "n" }, "<leader>gt", "<cmd>lua MiniDiff.toggle_overlay()<cr>", { desc = "Toggle Diff Overlay" })
  end
}
