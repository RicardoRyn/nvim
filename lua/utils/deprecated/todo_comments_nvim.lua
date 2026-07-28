if vim.g.vscode then
  return
end

require("mini.misc").safely("event:BufReadPost,BufNewFile", function()
  require("todo-comments").setup({
    signs = true,
    sign_priority = 8,
      -- stylua: ignore
      keywords = {
        FIX = { icon = require("utils.icons").comments.fix, color = "fix", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
        TODO = { icon = require("utils.icons").comments.todo, color = "todo", alt = { "WIP", "NEXT", "TASK" } },
        WARN = { icon = require("utils.icons").comments.warn, color = "warn", alt = { "WARNING" } },
        HACK = { icon = require("utils.icons").comments.hack, color = "hack", alt = { "XXX" } },
        PERF = { icon = require("utils.icons").comments.perf, color = "perf", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" }, },
        TEST = { icon = require("utils.icons").comments.test, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        TOG = { icon = require("utils.icons").comments.tog, color = "tog", alt = { "TOGGLE", "SETTING", "SWITCH", "CONFIG", "CONF" }, },
        SETTING = { icon = require("utils.icons").comments.setting, color = "setting", alt = { "TOGGLE", "SETTING", "SWITCH", "CONFIG", "CONF" }, },
        NOTE = { icon = require("utils.icons").comments.note, color = "note", alt = { "INFO", "NB", "REF", "DOCS" } },
      },
    gui_style = { fg = "ITALIC", bg = "BOLD" },
    colors = {
      fix = { "#dc2626" },
      todo = { "#f55e44" },
      warn = { "#df8e1d" },
      hack = { "#df8e1d" },
      perf = { "#6a2cbc" },
      test = { "#0496ff" },
      tog = { "#0496ff" },
      setting = { "#0496ff" },
      note = { "#179299" },
      default = { "#dc2626" },
    },
  })
end)

--  FIX: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  TODO: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  WARN: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  HACK: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  PERF: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  TEST: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  TOG: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  SETTING: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
--  NOTE: aaa bbb ccc
-- aaa bbb ccc
-- aaa bbb ccc
