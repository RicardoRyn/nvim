-- 在blink.lua中添加`require("snippets.lua")`以启动该snippet

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("lua", {
  s("notvscode", {
    t({
      "cond = not vim.g.vscode,",
    }),
  }),
  s("sty", {
    t("-- stylua: ignore"),
    i(0),
  }),
})
