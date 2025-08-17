return {
  "folke/which-key.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      {
        mode = { "n", "v" },
        { "g", group = "goto" },
        { "z", group = "fold" },

        -- 无下级菜单
        { "<leader>E", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>-", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>=", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>h", icon = { icon = "󰸱" } },
        { "<leader>v", group = "Virtual Env", icon = { icon = " ", color = "purple" } },

        { "<localleader>e", group = "Evaluate Operator", icon = { icon = " ", color = "purple" } },

        -- 有下级菜单
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>ft", group = "Find Todo" },
        { "<leader>g", group = "Git" },
        { "<leader>j", group = "Quarto Hydra", icon = { icon = "󱔕 " } },
        { "<leader>n", group = "Noice" },
        { "<leader>m", group = "Molten", icon = { icon = " ", color = "blue" } },
        { "<leader>o", group = "Output/Outline", icon = { icon = " ", color = "green" } },
        { "<leader>q", group = "Quarto", icon = { icon = " ", color = "blue" } },
        { "<leader>s", group = "Swap", icon = { icon = "󰯎 " } },
        { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>x", group = "Trouble", icon = { icon = "󱖫 ", color = "green" } },
        { "<leader><space>", group = "Hop", icon = { icon = "󱔕" } },

        { "<localleader>s", group = "Session" },
        { "<localleader>r", group = "Run", icon = { icon = " ", color = "green" } },


          -- stylua: ignore
          { "<leader>w", group = "Windows", proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
      },
    },
  },

  keys = {
    {
      "<c-w><space>",
      function()
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
