return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      prompt = {
        prefix = { { " FlashSearch: ", "FlashPromptIcon" } },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      { "xw", mode = { "n", "v" },
        function()
          require("flash").jump({
            pattern = vim.fn.expand("<cword>"),
          })
        end, desc = "Words"
      },
      { "xr", mode = { "n", "v" },
        function()
          require("flash").jump({continue = true})
        end, desc = "Resume"
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ff007c", bold = true })
    end,
  },
  {
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

      -- vim.keymap.set({ "n", "v" }, "<leader><leader>w", function()
      --   hop.hint_words({ direction = directions.AFTER_CURSOR, hint_position = positions.END })
      -- end, { desc = "Go to next any begining of words" })
      --
      -- vim.keymap.set({ "n", "v" }, "<leader><leader>e", function()
      --   hop.hint_words({ direction = directions.AFTER_CURSOR })
      -- end, { desc = "Go to next any end of words" })
      --
      -- vim.keymap.set({ "n", "v" }, "<leader><leader>b", function()
      --   hop.hint_words({ direction = directions.BEFORE_CURSOR, hint_position = positions.END })
      -- end, { desc = "Go to previous any begining of words" })
      --
      -- vim.keymap.set({ "n", "v" }, "<leader><leader>v", function()
      --   hop.hint_words({ direction = directions.BEFORE_CURSOR })
      -- end, { desc = "Go to previous any end of words" })
      --
    end,
  },
}
