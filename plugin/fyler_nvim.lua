if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("fyler").setup({
      -- Whether to skip confirmation for "simple" mutations.
      -- A simple mutation has at most:
      -- - 1 copy operation
      -- - 1 delete operation
      -- - 1 move operation
      -- - 5 create operations
      auto_confirm_simple_mutation = true,
      -- Restricts cursor from moving outside editable region
      bound_cursor = true,
      -- Buffer-local options applied to the finder buffer (see: nvim_set_option_value)
      buf_opts = {},
      -- Follow current file
      follow_current_file = false,
      -- List of extensions to enable (e.g., 'git', 'trash', 'watcher')
      extensions = {
        git = {
          enabled = true,
          icons = {
            [" M"] = { icon = "_M", hl = "MiniDiffSignChange" },
            ["M "] = { icon = "M_", hl = "MiniDiffSignChange" },
            ["MM"] = { icon = "MM", hl = "MiniDiffSignChange" },
            ["??"] = { icon = "??", hl = "MiniDiffSignAdd" },
            [" D"] = { icon = "_D", hl = "MiniDiffSignDelete" },
            ["D "] = { icon = "D_", hl = "MiniDiffSignDelete" },
            ["R "] = { icon = "R_", hl = "FylerGitRenamed" },
            ["UU"] = { icon = "UU", hl = "FylerGitConflict" },
            ["!!"] = { icon = "!!", hl = "FylerGitIgnored" },
          },
          inline = false,
        },
        watcher = {
          enabled = true,
        },
      },
      -- Event hooks for custom behavior (on_highlight, on_delete, on_rename)
      hooks = {},
      -- External integrations (e.g., icon provider)
      integrations = {
        icon = "mini_icons",
      },
      -- Window-local options applied to the finder window (see: nvim_set_option_value)
      win_opts = {
        winbar = "%!v:lua.Fyler.getcwd()",
      },
      -- Buffer kind to use globally.
      kind = "replace",
      -- Per-kind preset overrides. Each preset can contain mappings, buf_opts,
      -- win_opts, and any window layout fields (width, height, border, etc.).
      kind_presets = {
        floating = {
          -- Border style (see: :h winborder)
          border = "single",
          -- Size of buffer:
          -- - string with '%' for relative (e.g. '70%')
          -- - number for absolute
          height = "80%",
          mappings = { n = { ["<CR>"] = { action = "select", args = { close = true } } } },
          width = "60%",
          -- Horizontal alignment: 'start' | 'center' | 'end'
          col = "center",
          -- Vertical alignment: 'start' | 'center' | 'end'
          row = "center",
        },
        replace = {
          mappings = { n = { ["<CR>"] = { action = "select", args = { close = true } } } },
        },
        split_above = { height = "50%" },
        split_above_all = { height = "50%" },
        split_below = { height = "50%" },
        split_below_all = { height = "50%" },
        split_left = { width = "25%" },
        split_left_most = { width = "20%" },
        split_right = { width = "25%" },
        split_right_most = { width = "20%" },
      },
      mappings = {
        n = {
          ["-"] = { action = "visit", args = { parent = true } },
          ["."] = { action = "visit", args = { cursor = true } },
          ["<Esc>"] = { action = "shrink", args = { parent = true } },
          ["H"] = { action = "shrink", args = { parent = true } },
          ["<C-R>"] = { action = "refresh", args = { recursive = true, force = true } },
          ["<C-S>"] = { action = "select", args = { split = true } },
          ["<C-T>"] = { action = "select", args = { tabedit = true } },
          ["<C-V>"] = { disabled = true },
          ["_"] = { action = "select", args = { vsplit = true } },
          ["<CR>"] = { action = "select" },
          ["L"] = { action = "select" },
          ["="] = { action = "visit" },
          ["g."] = { action = "toggle_ui", args = { "hidden_items" } },
          ["gi"] = { action = "toggle_ui", args = { "indent_guides" } },
          ["q"] = { action = "close" },
          ["<leader>cc"] = {
            action = function(self)
              local node = require("fyler.finder").parse_cursor_line(self)
              if node then
                vim.fn.setreg("+", node.path)
                vim.notify("Copied: " .. node.path)
              end
            end,
          },
          ["<leader>cd"] = {
            action = function(self)
              local node = require("fyler.finder").parse_cursor_line(self)
              if node then
                local dir = vim.fs.dirname(node.path)
                vim.fn.setreg("+", dir)
                vim.notify("Copied: " .. dir)
              end
            end,
          },
          ["<leader>cf"] = {
            action = function(self)
              local node = require("fyler.finder").parse_cursor_line(self)
              if node then
                local filename = vim.fn.fnamemodify(node.path, ":t")
                vim.fn.setreg("+", filename)
                vim.notify("Copied: " .. filename)
              end
            end,
          },
        },
      },
      -- UI configuration
      ui = {
        hidden_items = {
          -- Toggleable pre-defined switches (e.g. 'dotfiles' to hide files starting with a dot).
          switches = { "dotfiles" },
          -- Toggleable patterns (Lua patterns matched against the full path).
          patterns = {},
          -- Always visible items matching these patterns, even if they would normally be hidden.
          always_visible = {},
          -- Always hide items matching these patterns, even if they would normally be visible.
          always_hidden = {},
        },
        -- Whether to draw indent guides at each depth level.
        indent_guides = true,
      },
    })
  end,
  keys = {
    { "n", "<leader>ee", function() require("fyler").toggle({ kind = "split_left_most" }) end, { desc = "Fyler" }, },
    { "n", "<leader>ef", function() require("fyler").toggle({ kind = "floating" }) end, { desc = "Fyler (floating)" }, },
    { "n", "<leader>er", function() require("fyler").toggle({ kind = "split_left_most", root_path = "~" }) end, { desc = "Fyler (root path)" }, },
  },
})
