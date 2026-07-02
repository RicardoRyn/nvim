if vim.g.vscode then return end

local miniclue = require("mini.clue")

miniclue.setup({
  window = {
    delay = 300,
    config = {
      -- Compute window width automatically
      width = "auto",
    },
  },
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<Leader>" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = { "n", "x" }, keys = "g" },

    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },

    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = { "n", "x" }, keys = "z" },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    { mode = "n", keys = "<Leader>a", desc = "AI" },
    { mode = "n", keys = "<Leader>b", desc = "Buffer" },
    { mode = "n", keys = "<Leader>D", desc = "Debug snacks" },
    { mode = "n", keys = "<Leader>d", desc = "DAP" },
    { mode = "n", keys = "<Leader>e", desc = "Files" },
    { mode = "n", keys = "<Leader>f", desc = "Find" },
    { mode = "n", keys = "<Leader>g", desc = "Git" },
    { mode = "n", keys = "<Leader>gh", desc = "Github" },
    { mode = "n", keys = "<Leader>j", desc = "JJ" },
    { mode = "n", keys = "<Leader>l", desc = "LSP" },
    { mode = "n", keys = "<Leader>m", desc = "Map" },
    { mode = "n", keys = "<Leader>P", desc = "Pack" },
    { mode = "n", keys = "<Leader>s", desc = "Search" },
    { mode = "n", keys = "<Leader>t", desc = "Tab/Terminal" },
    { mode = "n", keys = "<Leader>u", desc = "UI" },
    { mode = "n", keys = "<Leader>/", desc = "Grep" },
  },
})
