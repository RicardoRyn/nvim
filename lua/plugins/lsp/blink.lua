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
    { "Exafunction/windsurf.nvim" },
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
      ['<CR>'] = { 'accept', 'fallback' },
      -- ['<Tab>'] = { 'select_and_accept', 'fallback' },
      ['<Tab>'] = false, -- 为了Tab键能更好地执行AI自动补全
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
  -- blink的虚拟文本颜色
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#ffcc00", italic = true })
  end,
}
