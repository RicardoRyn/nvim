return {
  "saghen/blink.cmp",
  cond = not vim.g.vscode,
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      config = function()
        -- 添加需要的snippet
        require("snippets.lua")
      end,
    },
  },
  -- stylua: ignore
  opts = {
    completion = {
      documentation = {
        auto_show = false,
      },
      list = {
        selection = { preselect = true, auto_insert = false }
      }
    },
    keymap = {
      ['<Tab>'] = { 'accept', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-y>'] = false,
    },
    cmdline = {
      keymap = { preset = 'inherit' },
      completion = {
        menu = {
          auto_show = true
        },
        list = {
          selection = { preselect = false, auto_insert = false }
        },
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "path", "snippets", "buffer", "lsp" },
    },
  },
}
