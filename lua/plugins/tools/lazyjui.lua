return {
  "mrdwarf7/lazyjui.nvim",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      -- Default is <Leader>jj
      -- An example of a custom mapping to open the interface
      "<Leader>gj",
      function()
        require("lazyjui").open()
      end,
    },
  },
  -- You can also simply pass `opts = true` or `opts = {}` and the default options will be used
  opts = {
    -- Optionally:
    border_chars = {}, -- to remove the entire outer border (or nil)
    -- or
    -- Use custom set of border chars (must be 8 long)
    -- border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },

    -- Support for custom command pass-through
    -- In this example, we use the revset `all()` command
    --
    -- Will default to just `jjui`
    cmd = { "jjui", "-r", "all()" },
    height = 1, -- default is 0.8,
    width = 1, -- default is 0.9,
    winblend = 0, -- default is 0 (fully opaque). Set to 100 for fully transparent (not recommended though).
  },
}
