local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
  s("mydef", {
    t("def "), i(1, "func_name"), t("("), i(2, "args"), t({"):", "\t"}),
    i(0),
  }),
})
