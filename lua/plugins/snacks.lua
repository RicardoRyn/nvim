return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      width = 30,
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
        ██████╗ ██╗   ██╗███╗   ██╗    ██╗   ██╗██╗███╗   ███╗
        ██╔══██╗╚██╗ ██╔╝████╗  ██║    ██║   ██║██║████╗ ████║
        ██████╔╝ ╚████╔╝ ██╔██╗ ██║    ██║   ██║██║██╔████╔██║
        ██╔══██╗  ╚██╔╝  ██║╚██╗██║    ╚██╗ ██╔╝██║██║╚██╔╝██║
        ██║  ██║   ██║   ██║ ╚████║     ╚████╔╝ ██║██║ ╚═╝ ██║
        ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝      ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      },
    },
    image = { enabled = true }, -- PERF: wezterm需要nightly版本，才能显示 [参见](https://github.com/folke/snacks.nvim/discussions/1720)
    indent = { enabled = false, },
    input = { enabled = true },
    notifier = { enabled = true },
    -- TODO: 切换icons
    -- icons = {
    --   error = " ",
    --   warn = " ",
    --   info = " ",
    --   debug = " ",
    --   trace = " ",
    -- },
    scope = { enabled = false }, -- TODO: 这是啥？
    statuscolumn = { enabled = true }, -- TODO: 这是啥？
    words = { enabled = false }, -- TODO: 这是啥？
  },
  -- stylua: ignore
  keys = {
    -- Picker
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- find
    { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- grep
    { "<leader>//", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>/b", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>/B", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>/w", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- git
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "Open LazyGit", },
    -- TODO: 判断哪可以取代gitsigns
    -- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    -- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s.', function() Snacks.scratch.select() end, desc = "Scratch" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- todo
    { "<leader>ftt", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>ftT", function () Snacks.picker.todo_comments({ keywords = { "FIX", "TODO", "HACK", "WARN" } }) end, desc = "Todo/Fix/Fixme" },
    -- code
    { "<leader>cu", function() Snacks.picker.undo() end, desc = "Undo History" },
    -- ui
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- terminal
    { "<C-_>", function() Snacks.terminal.open() end, desc = "Open Terminal" },
    { "<C-_>", function() Snacks.terminal.toggle(nil, { shell = "nu", cwd = nil }) end, mode = { "n", "t" }, desc = "Open Terminal" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.dim():map("<leader>ud")
        Snacks.toggle.zen():map("<leader>uz")
        Snacks.toggle.zoom():map("<leader>uZ")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.diagnostics():map("<leader>ux")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
      end,
    })
  end,
}
