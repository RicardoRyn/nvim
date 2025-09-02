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
    vim.keymap.set({ "n", "v" }, "<leader><leader>w", function()
      hop.hint_words({ direction = directions.AFTER_CURSOR, hint_position = positions.END })
    end, { desc = "Go to next any begining of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>e", function()
      hop.hint_words({ direction = directions.AFTER_CURSOR })
    end, { desc = "Go to next any end of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>b", function()
      hop.hint_words({ direction = directions.BEFORE_CURSOR, hint_position = positions.END })
    end, { desc = "Go to previous any begining of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>v", function()
      hop.hint_words({ direction = directions.BEFORE_CURSOR })
    end, { desc = "Go to previous any end of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>l", function()
      hop.hint_camel_case({ direction = directions.AFTER_CURSOR, hint_position = positions.END })
    end, { desc = "Go to next any begining of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>h", function()
      hop.hint_camel_case({ direction = directions.BEFORE_CURSOR, hint_position = positions.END })
    end, { desc = "Go to previous any begining of words" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>j", function()
      hop.hint_lines({ direction = directions.AFTER_CURSOR })
    end, { desc = "Go to line below" })
    vim.keymap.set({ "n", "v" }, "<leader><leader>k", function()
      hop.hint_lines({ direction = directions.BEFORE_CURSOR })
    end, { desc = "Go to line above" })
  end,
}
