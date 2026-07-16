if vim.g.vscode then return end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = vim.api.nvim_create_augroup("SetupBlink", { clear = true }),
  callback = function()
    local cmp = require("blink.cmp")
    cmp.build():pwait()
    cmp.setup({
      completion = {
        documentation = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = false } },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
        },
      },
      -- stylua: ignore
      keymap = {
        ["<Tab>"] = { "accept", function() return require("sidekick").nes_jump_or_apply() end, "fallback", },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = false,
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
          list = { selection = { preselect = false, auto_insert = false } },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
        per_filetype = {
          tex = { inherit_defaults = true, "omni" },
        },
      },
    })
  end,
})
