return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    animate = { enabled = true },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    dashboard = {
      enabled = true,
      width = 30,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
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
    debug = { enabled = false },
    dim = { enabled = false },
    explorer = { enabled = false },
    git = { enabled = true },
    gitbrowse = { enabled = false },
    -- FIX: wezterm打开带图片的readme文件时,会出现问题
    image = { enabled = false },
    indent = { enabled = true },
    input = { enabled = true },
    layout = { enabled = false },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    notify = { enabled = true },
    picker = { enabled = true },
    profiler = { enabled = false },
    quickfile = { enabled = true },
    rename = { enabled = false },
    scope = { enabled = true }, -- 高亮当前作用域
    scratch = { enabled = true },
    scroll = { enabled = true }, -- 平滑滚动
    statuscolumn = { enabled = true }, -- 状态列
    terminal = { enabled = true },
    toggle = {
      map = vim.keymap.set, -- keymap.set function to use
      which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
      notify = true, -- show a notification when toggling
      -- icons for enabled/disabled states
      icon = {
        enabled = " ",
        disabled = " ",
      },
      -- colors for enabled/disabled states
      color = {
        enabled = "green",
        disabled = "yellow",
      },
      wk_desc = {
        enabled = "Disable ",
        disabled = "Enable ",
      },
    },
    util = { enabled = false },
    words = { enabled = true },
    zen = { enabled = true },
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
    { "<leader>uz", function() Snacks.zen.zen() end, desc = "Zen" },
    { "<leader>uZ", function() Snacks.zen.zoom() end, desc = "Zoom" },
    -- terminal
    { "<C-_>", function() Snacks.terminal.open() end, desc = "Open Terminal" },
    { "<C-_>", function() Snacks.terminal.toggle(nil, { shell = "nu", cwd = nil }) end, mode = { "n", "t" }, desc = "Open Terminal" },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    -- Snacks.toggle.zen():map("<leader>uz")
    -- Snacks.toggle.zen():map("<leader>uZ")
  end
}
