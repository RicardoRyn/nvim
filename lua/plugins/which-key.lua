return {
  "folke/which-key.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "helix",
    defaults = {},
    spec = {
      -- stylua: ignore
      {
        mode = { "n", "v" },
        { "g", group = "Goto" },
        { "z", group = "Fold" },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        -- 无下级菜单
        { "<leader>d", group = "Docstrings", icon = { icon = "󰙆 " } },
        { "<leader>e", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>z", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>.", group = "Scratch", icon = {icon = " "}},
        { "<leader>:", group = "Command History", icon = {icon = " "}},
        { "<leader>;", group = "Dropbar", icon = {icon = "󰁊 "}},
        -- 有下级菜单
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code/CSV" },
        { "<leader>cs", group = "CSV" },
        { "<leader>cv", group = "Virtual Env", icon = { icon = " ", color = "purple" } },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Home", icon = { icon = "󰋜 " } },
        { "<leader>n", group = "Noice" },
        { "<leader>o", group = "Outline", icon = { icon = " ", color = "green" } },
        { "<leader>r", group = "Restart LSP", icon = { icon = " " } },
        { "<leader>s", group = "Search" },
        { "<leader>S", group = "Session" },
        { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>w", group = "Windows", proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
        { "<leader><space>", group = "Smart Files" },
        { "<leader>/", group = "Grep", icon = { icon = " " } },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "Window Hydra Mode (which-key)"},
    { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)"},
  },
}
