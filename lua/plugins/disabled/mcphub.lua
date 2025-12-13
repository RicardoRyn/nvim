return {
  "ravitemer/mcphub.nvim",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    require("mcphub").setup()
  end,
}
