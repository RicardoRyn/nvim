if vim.g.vscode then
  return {}
else
  return {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", version = "v2.*" },
    },
    event = "VeryLazy",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      keymap = {
        preset = "super-tab",
      },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "path", "snippets", "buffer", "lsp" },
      },
    },
  }
end
