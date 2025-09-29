return {
  "Bekaboo/dropbar.nvim",
  cond = not vim.g.vscode,
  -- optional, but required for fuzzy finder support
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  opts = {
  },
  config = function(_, opts)
    require("dropbar").setup({ opts })

    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Dropbar" })
    vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end,
}
