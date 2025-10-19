return {
  "mrjones2014/smart-splits.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    -- 窗口切换
    { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below window" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above window" },
    -- 窗口大小调整
    { "<C-Left>",  function() require("smart-splits").resize_left() end,  desc = "Resize window left" },
    { "<C-Right>", function() require("smart-splits").resize_right() end, desc = "Resize window right" },
    { "<C-Down>",  function() require("smart-splits").resize_down() end,  desc = "Resize window down" },
    { "<C-Up>",    function() require("smart-splits").resize_up() end,    desc = "Resize window up" },
  },
}
