return {
  "hedyhli/outline.nvim",
  cond = not vim.g.vscode,
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>oo", "<cmd>Outline<CR>", desc = "Toggle Outline" },
  },
  opts = {
    -- Your setup opts here
  },
}
