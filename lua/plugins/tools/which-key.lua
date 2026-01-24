return {
  "folke/which-key.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      -- stylua: ignore
      {
        mode = { "n", "v" },
        { "g", group = "Goto" },
        { "z", group = "Fold" },
        { "[", group = "Prev" },
        { "]", group = "Next" },
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Copy/CSV", icon = { icon = "󰆏 " } },
        { "<leader>cs", group = "CSV", icon = { icon = " " } },
        { "<leader>d", group = "Debug" },
        { "<leader>D", group = "Docstrings", icon = { icon = "󰙆 " } },
        { "<leader>e", group = "File Explorer", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "GitHub" },
        { "<leader>gj", group = "JJui"},
        { "<leader>h", group = "Home", icon = { icon = " " } },
        { "<leader>j", group = "Jujutsu", icon = { icon = " ", color = "blue" } },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "purple" } },
        { "<leader>L", group = "Lazy" },
        { "<leader>lm", group = "Toggle Code Block" },
        { "<leader>ls", group = "LSP", icon = { icon = " ", color = "purple" } },
        { "<leader>lv", group = "Virtual Env", icon = { icon = " ", color = "purple" } },
        { "<leader>n", group = "Noice" },
        { "<leader>o", group = "Outline", icon = { icon = " ", color = "green" } },
        { "<leader>s", group = "Search" },
        { "<leader>S", group = "Session" },
        { "<leader>t", group = "Tab" },
        { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>w", group = "Windows", proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
        { "<leader>x", group = "QuickFix", icon = { icon = "󱖫 ", color = "red" } },
        { "<leader>z", icon = { icon = "󰙅"} },
        { "<leader><space>", group = "Smart Files", icon = { icon = " " } },
        { "<leader>.", group = "Scratch", icon = {icon = " "}},
        { "<leader>:", group = "Command History", icon = {icon = " "}},
        { "<leader>/", group = "Grep", icon = { icon = " " } },
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
