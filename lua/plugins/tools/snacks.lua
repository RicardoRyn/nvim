-- 安装gh
-- gh auth login
-- gh extension install meiji163/gh-notify
-- 由于Windows上类Unix脚本的Shebang路径问题，可能需要修改gh-notify的脚本
local dbAnim = require("utils.dashboardAnimation")
local snacks_dashboard = require("utils.snacks_dashboard")
local snacks_explorer_preview = require("utils.snacks_explorer_preview")

return {
  "folke/snacks.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  opts = {
    bigfile = { enabled = true },
    dashboard = snacks_dashboard,
    explorer = { enabled = true },
    gh = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true, indent = { char = "▏" }, scope = { char = "▍", hl = "" } },
    input = { enabled = true },
    picker = { enabled = true, sources = { explorer = snacks_explorer_preview } },
    notifier = { enabled = false, timeout = 3000 },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = { notification = { wo = { wrap = true } } },
  },
  -- stylua: ignore
  keys = {
    -- file
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>ft", function() Snacks.picker.todo_comments({ buffers = true }) end, desc = "Todo (Buffers)" },
    { "<leader>fT", function() Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" }, buffers = true }) end, desc = "Todo/Fix (Buffers)" },
    -- grep
    { "<leader>//", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>/l", function() Snacks.picker.lines() end, desc = "Lines" },
    { "<leader>/b", function() Snacks.picker.grep_buffers() end, desc = "Buffers" },
    { "<leader>/w", function() Snacks.picker.grep_word() end, desc = "Word", mode = { "n", "x" } },
    -- search
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>.", function() Snacks.scratch() end, desc = "Scratch" },
    { "<leader>:", function() Snacks.picker.command_history() end, mode = { "n", "v" }, desc = "Command History" },
    { "<leader>z", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s.', function() Snacks.scratch.select() end, desc = "Scratch" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics (buffer)" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sI", function() Snacks.picker.lsp_incoming_calls() end, desc = "Incoming Calls" },
    { "<leader>sJ", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sL", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sO", function() Snacks.picker.lsp_outgoing_calls() end, desc = "Outgoing Calls" },
    { "<leader>sp", function() Snacks.picker.spelling() end, desc = "Spelling" },
    { "<leader>sP", function() Snacks.picker() end, desc = "Pickers" },
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" } }) end, desc = "Todo/Fix" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>sv", function() Snacks.picker.cliphist() end, desc = "Clipboard History" },
    -- LSP
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Symbols (workspace)" },
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    -- git
    { "<leader>gg", function() require("snacks").lazygit.open() end, desc = "LazyGit", },
    { "<leader>ghi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>ghI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>ghp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>ghP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- terminal
    { "<C-/>", function() Snacks.terminal(nil, { win = { height = 0.3, position = "bottom", } }) end, mode = { "n", "t" }, desc = "Open Terminal" },
    { "<C-_>", function() Snacks.terminal(nil, { win = { height = 0.3, position = "bottom", } }) end, mode = { "n", "t" }, desc = "Open Terminal" },
    -- ui
    { "<leader>es", function() Snacks.explorer() end, desc = "File Explorer" },
    { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { '<leader>h', function() Snacks.dashboard() end, desc = "Home Page" },
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
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.zoom():map("<leader>uz")
        Snacks.toggle.zen():map("<leader>uZ")
      end,
    })

    -- 等待 Catppuccin 加载完成后异步初始化动画配置
    -- 延迟 10ms 以确保能够获取到当前 flavour 的正确色板 (Palette)
    vim.defer_fn(function()
      local flavour = require("catppuccin").flavour
      local colors = require("catppuccin.palettes").get_palette(flavour)
      dbAnim.theAnimation(dbAnim.theAnimation, colors)

      -- 若非透明模式下为 latte 模式，则手动覆盖 CursorLine 背景色以优化视觉效果
      local catppuccin = require("catppuccin")
      if not catppuccin.options.transparent_background and catppuccin.flavour == "latte" then
        vim.cmd([[highlight CursorLine guibg=#dce0e8]])
      end
    end, 1)
  end,
}
