return {
  "akinsho/bufferline.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  -- stylua: ignore
  keys = {
    -- { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    -- { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Buffer", },
    -- { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    -- { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    -- { "<leader>bb", ":BufferLinePickClose<CR>", desc = "Delete Pick Buffer" },
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>ba", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    -- { "<leader>b<", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Prev" },
    -- { "<leader>b>", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Next" },
    -- { "<b",
    --   function()
    --     local dir = -1
    --     local moveBy = vim.v.count > 0 and vim.v.count or 1
    --     local bufferline = require("bufferline")
    --     for _ = 1, moveBy do
    --       bufferline.move(dir)
    --     end
    --   end,
    --   desc = "Move current buffer to left",
    -- },
    -- { ">b",
    --   function()
    --     local dir = 1
    --     local moveBy = vim.v.count > 0 and vim.v.count or 1
    --     local bufferline = require("bufferline")
    --     for _ = 1, moveBy do
    --       bufferline.move(dir)
    --     end
    --   end,
    --   desc = "Move current buffer to right",
    -- },
  },
  opts = {
    options = {
      mode = "tabs",
      always_show_bufferline = false,
      separator_style = "thin",
      indicator = {
        icon = " ",
        style = "icon", -- 'icon' | 'underline' | 'none'
      },
      close_command = function(n) Snacks.bufdelete(n) end,
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local indicator = "  "
        for level, number in pairs(diagnostics_dict) do
          local symbol
          if level == "error" then
            symbol = require("utils.icons").diagnostics.error .. " "
          elseif level == "warning" then
            symbol = require("utils.icons").diagnostics.warning .. " "
          elseif level == "info" then
            symbol = require("utils.icons").diagnostics.info .. " "
          elseif level == "hint" then
            symbol = require("utils.icons").diagnostics.hint .. " "
          end
          indicator = indicator .. number .. symbol
        end
        return indicator
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "󰙅 Neo-Tree",
          highlight = "Directory",
          text_align = "center",
          separator = false,
        },
      },
    },
  },
  config = function (_, opts)
    require("bufferline").setup(opts)
    require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " })
  end
}
