return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  cond = not vim.g.vscode,
  config = function()
    local ls = require("luasnip")

    -- Load custom snippets from snippets directory
    require("luasnip.loaders.from_lua").lazy_load()

    -- Load friendly snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Keymaps for snippet navigation
    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-h>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
  end,
}
