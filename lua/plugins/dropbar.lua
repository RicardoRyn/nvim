return {
  "Bekaboo/dropbar.nvim",
  cond = not vim.g.vscode,
  -- optional, but required for fuzzy finder support
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  config = function()
    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick Symbols in Dropbar" })
    -- vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    -- vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
