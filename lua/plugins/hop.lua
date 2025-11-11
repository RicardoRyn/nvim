return {
  "smoka7/hop.nvim",
  event = "VeryLazy",
  version = "*",
  opts = {},
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    local positions = require("hop.hint").HintPosition
    hop.setup({}) -- 初始化插件

    vim.keymap.set({ "n", "v" }, "xj", function()
      hop.hint_lines({ direction = directions.AFTER_CURSOR })
    end, { desc = "Go to line below" })

    vim.keymap.set({ "n", "v" }, "xk", function()
      hop.hint_lines({ direction = directions.BEFORE_CURSOR })
    end, { desc = "Go to line above" })

    vim.keymap.set({ "n", "v" }, "xl", function()
      hop.hint_camel_case({ direction = directions.AFTER_CURSOR })
    end, { desc = "Go to next any begining of words" })

    vim.keymap.set({ "n", "v" }, "xh", function()
      hop.hint_camel_case({ direction = directions.BEFORE_CURSOR })
    end, { desc = "Go to previous any begining of words" })
  end,
}
