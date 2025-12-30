return {
  {
    "folke/flash.nvim",
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
    opts = {
      prompt = {
        prefix = { { " FlashSearch: ", "FlashPromptIcon" } },
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ff007c", bold = true })
    end,
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      {
        "xj",
        function()
          require("hop").hint_lines({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
        end,
        desc = "Go to line below",
        mode = { "n", "v" },
      },
      {
        "xk",
        function()
          require("hop").hint_lines({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
        end,
        desc = "Go to line above",
        mode = { "n", "v" },
      },
      {
        "xl",
        function()
          require("hop").hint_camel_case({ direction = require("hop.hint").HintDirection.AFTER_CURSOR })
        end,
        desc = "Go to next any begining of words",
        mode = { "n", "v" },
      },
      {
        "xh",
        function()
          require("hop").hint_camel_case({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
        end,
        desc = "Go to previous any begining of words",
        mode = { "n", "v" },
      },
    },
    opts = {},
  },
}
