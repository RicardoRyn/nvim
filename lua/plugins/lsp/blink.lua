return {
  "saghen/blink.cmp",
  cond = not vim.g.vscode,
  version = "*",
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    { "xzbdmw/colorful-menu.nvim", opts = {} },
  },
  event = "VeryLazy",
  -- stylua: ignore
  opts = {
    completion = {
      documentation = {
        auto_show = false,
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 }, {"label_description"}, {"source_name"} },
          components = {
            label = {
              text = function(ctx) return require("colorful-menu").blink_components_text(ctx) end,
              highlight = function(ctx) return require("colorful-menu").blink_components_highlight(ctx) end,
            },
          },
        },
      },
      list = {
        selection = { preselect = true, auto_insert = false }
      }
    },
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = { 'select_and_accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
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
      default = { "path", "snippets", "buffer", "lsp", "codeium" },
      providers = {
        codeium = { name = 'Codeium', module = 'codeium.blink', async = true }
      }
    },
  },
}
