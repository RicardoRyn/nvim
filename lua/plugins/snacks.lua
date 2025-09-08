-- 安装gh
-- gh auth login
-- gh extension install meiji163/gh-notify
-- 由于Windows上类Unix脚本的Shebang路径问题，可能需要修改gh-notify的脚本
return {
  "folke/snacks.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "s", desc = "Session", section = "session" },
          { icon = " ", key = "f", desc = "Find Files", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = " ", key = "w", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
          { icon = " ", key = "b", desc = "Browse Repo", action = ":lua Snacks.gitbrowse()", },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
           ██████╗ ██╗   ██╗███╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
           ██╔══██╗╚██╗ ██╔╝████╗  ██║██║   ██║██║████╗ ████║      Z    
           ██████╔╝ ╚████╔╝ ██╔██╗ ██║██║   ██║██║██╔████╔██║   z       
           ██╔══██╗  ╚██╔╝  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║ z         
           ██║  ██║   ██║   ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║           
           ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝           ]],
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    explorer = { enabled = false },
    image = { enabled = true },
    indent = { enabled = true, indent = { char = "▏" }, scope = { char = "▍", hl = "" } },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Picker
    -- { "<leader>e", function() Snacks.explorer() end, desc = "Explorer (cwd)" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Scratch" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    -- find
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    -- grep
    { "<leader>//", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>/l", function() Snacks.picker.lines() end, desc = "Lines" },
    { "<leader>/b", function() Snacks.picker.grep_buffers() end, desc = "Buffers" },
    { "<leader>/w", function() Snacks.picker.grep_word() end, desc = "Word", mode = { "n", "x" } },
    -- git
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "Open LazyGit", },
    -- search
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s.', function() Snacks.scratch.select() end, desc = "Scratch" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Symbols (workspace)" },
    -- terminal
    { "<C-/>", function() Snacks.terminal.open() end, desc = "Open Terminal" },
    { "<C-/>", function() Snacks.terminal.toggle(nil, { shell = "nu", cwd = nil }) end, mode = { "n", "t" }, desc = "Open Terminal" },
    { "<C-_>", function() Snacks.terminal.open() end, desc = "Open Terminal" },
    { "<C-_>", function() Snacks.terminal.toggle(nil, { shell = "nu", cwd = nil }) end, mode = { "n", "t" }, desc = "Open Terminal" },
    -- code
    { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" } }) end, desc = "Todo/Fix" },
    -- ui
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.dim():map("<leader>uD")
        Snacks.toggle({
          name = "Git Signs",
          get = function()
            return require("gitsigns.config").config.signcolumn
          end,
          set = function(state)
            require("gitsigns").toggle_signs(state)
          end,
        }):map("<leader>ug")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")
        Snacks.toggle.line_number():map("<leader>uL")
        Snacks.toggle.zen():map("<leader>uz")
        Snacks.toggle.zoom():map("<leader>uZ")
      end,
    })
  end,
}
