require("mini.misc").safely("later", function()
  local MiniAi = require("mini.ai")
  local MiniExtra = require("mini.extra")

  MiniAi.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      D = MiniExtra.gen_ai_spec.diagnostic(),
      I = MiniExtra.gen_ai_spec.indent(),
      L = MiniExtra.gen_ai_spec.line(),
      N = MiniExtra.gen_ai_spec.number(),
    },
  })
end)
