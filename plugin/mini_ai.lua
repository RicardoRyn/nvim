local ai = require("mini.ai")

ai.setup({
  mappings = {
    around_next = "aN",
    inside_next = "iN",
    around_last = "aL",
    inside_last = "iL",
  },
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    n = ai.gen_spec.treesitter({ a = "@conditional.outer", i = "@conditional.inner" }),
    o = ai.gen_spec.treesitter({
      a = { "@conditional.outer", "@loop.outer" },
      i = { "@conditional.inner", "@loop.inner" },
    }),
    k = ai.gen_spec.treesitter({ a = "@code_cell.outer", i = "@code_cell.inner" }),
    a = ai.gen_spec.treesitter({ a = "@assignment.outer", i = "@assignment.inner" }),
    l = ai.gen_spec.treesitter({ a = "@assignment.lhs", i = "@assignment.lhs" }),
    r = ai.gen_spec.treesitter({ a = "@assignment.rhs", i = "@assignment.rhs" }),
    s = ai.gen_spec.treesitter({ a = "@local.scope", i = "@local.scope" }),
    z = ai.gen_spec.treesitter({ a = "@fold", i = "@fold" }),
  },
})
