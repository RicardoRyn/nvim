return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        -- stylua: ignore
        keys = {
          { icon = " ", key = "N", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "s", desc = "Session", section = "session" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "w", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
          { icon = " ", key = "b", desc = "Browse Repo", action = ":lua Snacks.gitbrowse()", },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
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
      sections = {
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              icon = " ",
              title = "Git Status",
              cmd = "git --no-pager diff --stat -B -M -C",
              height = 10,
            },
            {
              icon = " ",
              title = "Notifications",
              cmd = "gh notify -s -a -n5",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              height = 5,
              enabled = true,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 5,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3",
              key = "P",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 5,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 2,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
      },
    },
    explorer = { enabled = true }, -- TODO: 修改各种快捷键
    image = { enabled = true },
    indent = { enabled = true, indent = { char = "▏" }, scope = { char = "▍", hl = "" } },
    input = { enabled = true },
    picker = {
      enabled = true,
      -- 浮动窗口预览文件
      sources = {
        explorer = {
          on_show = function(picker)
            local show = false
            local gap = 1
            local clamp_width = function(value)
              return math.max(20, math.min(100, value))
            end
            --
            local position = picker.resolved_layout.layout.position
            local rel = picker.layout.root
            local update = function(win) ---@param win snacks.win
              local border = win:border_size().left + win:border_size().right
              win.opts.row = vim.api.nvim_win_get_position(rel.win)[1]
              win.opts.height = 0.8
              if position == "left" then
                win.opts.col = vim.api.nvim_win_get_width(rel.win) + gap
                win.opts.width = clamp_width(vim.o.columns - border - win.opts.col)
              end
              if position == "right" then
                win.opts.col = -vim.api.nvim_win_get_width(rel.win) - gap
                win.opts.width = clamp_width(vim.o.columns - border + win.opts.col)
              end
              win:update()
            end
            local preview_win = Snacks.win.new({
              relative = "editor",
              external = false,
              focusable = false,
              border = "rounded",
              backdrop = false,
              show = show,
              bo = {
                filetype = "snacks_float_preview",
                buftype = "nofile",
                buflisted = false,
                swapfile = false,
                undofile = false,
              },
              on_win = function(win)
                update(win)
                picker:show_preview()
              end,
            })
            rel:on("WinLeave", function()
              vim.schedule(function()
                if not picker:is_focused() then
                  picker.preview.win:close()
                end
              end)
            end)
            rel:on("WinResized", function()
              update(preview_win)
            end)
            picker.preview.win = preview_win
            picker.main = preview_win.win
          end,
          on_close = function(picker)
            picker.preview.win:close()
          end,
          layout = {
            preset = "sidebar",
            preview = false, ---@diagnostic disable-line
          },
          actions = {
            -- `<A-p>`
            toggle_preview = function(picker) --[[Override]]
              picker.preview.win:toggle()
            end,
          },
        },
      },
    },
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
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer (cwd)" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Scratch" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    -- find
    { "<leader>ff", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
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
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s.', function() Snacks.scratch.select() end, desc = "Scratch" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification" },
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
    -- ui
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    -- code
    { "<leader>cu", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" } }) end, desc = "Todo/Fix" },
    -- misc
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Create some toggle mappings
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.dim():map("<leader>ud")
        Snacks.toggle({
          name = "Git Signs",
          get = function() return require("gitsigns.config").config.signcolumn end,
          set = function(state) require("gitsigns").toggle_signs(state) end,
        }):map("<leader>ug")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ui")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")
        Snacks.toggle.line_number():map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ux")
        Snacks.toggle.zen():map("<leader>uz")
        Snacks.toggle.zoom():map("<leader>uZ")
      end,
    })
  end,
}
