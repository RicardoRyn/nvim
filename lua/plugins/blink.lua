return {
  "saghen/blink.cmp",
  cond = not vim.g.vscode,
  event = { "InsertEnter", "CmdlineEnter" },
  version = "1.*",
  dependencies = { { "rafamadriz/friendly-snippets" } },
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
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
}
