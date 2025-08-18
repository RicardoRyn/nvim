return {
  "saghen/blink.cmp",
  cond = function()
    return not vim.g.vscode
  end,
  version = "*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    { "L3MON4D3/LuaSnip", version = "v2.*" },
    { "xzbdmw/colorful-menu.nvim", opts = {} },
  },
  event = "VeryLazy",
  opts = {
    menu = { border = "single" },
    completion = {
      documentation = {
        auto_show = true,
        window = { border = "single" },
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    keymap = {
      preset = "super-tab",
    },
    signature = {
      enabled = false, -- PERF: 查清楚现在的函数签名的来源
      window = { border = "single" },
    },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "path", "snippets", "buffer", "lsp" },
    },
  },
}
