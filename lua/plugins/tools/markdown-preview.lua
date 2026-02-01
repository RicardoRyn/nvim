return {
  "iamcco/markdown-preview.nvim",
  cond = not vim.g.vscode,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- build = "try { cd app; npm install }",
  ft = { "markdown" },
  keys = {
    {
      "<leader>um",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
