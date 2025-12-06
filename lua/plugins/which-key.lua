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
        { "<leader>c", group = "CSV", icon = { icon = "󰆏 " } },
        { "<leader>cs", group = "CSV", icon = { icon = " " } },
        { "<leader>d", group = "Docstrings", icon = { icon = "󰙆 " } },
        { "<leader>e", icon = { icon = "󰙅", color = "yellow" } },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "GitHub" },
        { "<leader>h", group = "Home", icon = { icon = " " } },
        { "<leader>l", group = "LSP", icon = { icon = " ", color = "purple" } },
        { "<leader>ls", group = "LSP", icon = { icon = " ", color = "purple" } },
        { "<leader>lv", group = "Virtual Env", icon = { icon = " ", color = "purple" } },
        { "<leader>m", group = "Toggle Code Block" },
        { "<leader>n", group = "Noice" },
        { "<leader>o", group = "Outline", icon = { icon = " ", color = "green" } },
        { "<leader>s", group = "Search" },
        { "<leader>S", group = "Session" },
        { "<leader>t", group = "Tab" },
        { "<leader>u", group = "UI", icon = { icon = "󰙵 ", color = "cyan" } },
        { "<leader>w", group = "Windows", proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
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
        -- 标志进入 hydra 模式，由lualine显示
        vim.g.window_hydra = true
        require("which-key").show({ keys = "<c-w>", loop = true })
      end,
      desc = "Window Hydra Mode (which-key)",
    },
    {
      "<esc>",
      function()
        if vim.g.window_hydra then
          -- 只在 hydra 模式下执行你的退出逻辑
          vim.g.window_hydra = false
          vim.cmd("nohlsearch")
        else
          -- 不在 hydra 模式 -> 发送真正的 ESC（恢复原本功能）
          local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
          vim.api.nvim_feedkeys(esc, "n", false)
        end
      end,
      mode = { "n", "v" },
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
