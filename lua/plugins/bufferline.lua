return {
  "akinsho/bufferline.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "famiu/bufdelete.nvim",
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local indicator = "  "
        for level, number in pairs(diagnostics_dict) do
          local symbol
          if level == "error" then
            symbol = require("config.icons").diagnostics.error .. " "
          elseif level == "warning" then
            symbol = require("config.icons").diagnostics.warning .. " "
          else
            symbol = require("config.icons").diagnostics.info .. " "
          end
          indicator = indicator .. number .. symbol
        end
        return indicator
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    {
      "<leader>bd",
      function()
        local buf = vim.api.nvim_get_current_buf()
        require("bufdelete").bufdelete(buf, false)
      end,
      desc = "Delete Duffer",
    },
    { "<leader>bo", ":BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<leader>bb", ":BufferLinePickClose<CR>", desc = "Delete Pick Buffer" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>ba", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    -- {
    --   "<leader>ba",
    --   function()
    --     vim.cmd("BufferLineCloseOthers")
    --     local buf = vim.api.nvim_get_current_buf()
    --     require("bufdelete").bufdelete(buf, false)
    --   end,
    --   desc = "Delete All Buffers",
    --   silent = true,
    -- },

    { "<leader>b<", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Prev" },
    { "<leader>b>", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Next" },

    -- 自定义移动buffer左右的按键 <b 和 >b
    {
      "<b",
      function()
        local dir = -1
        local moveBy = vim.v.count > 0 and vim.v.count or 1
        local bufferline = require("bufferline")
        for _ = 1, moveBy do
          bufferline.move(dir)
        end
      end,
      desc = "Move current buffer to left",
    },
    {
      ">b",
      function()
        local dir = 1
        local moveBy = vim.v.count > 0 and vim.v.count or 1
        local bufferline = require("bufferline")
        for _ = 1, moveBy do
          bufferline.move(dir)
        end
      end,
      desc = "Move current buffer to right",
    },
  },
  lazy = false,
}
