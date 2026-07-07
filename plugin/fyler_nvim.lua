if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("fyler").setup({
      auto_confirm_simple_mutation = true,
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
      integrations = {
        icon = "mini_icons",
      },
      win_opts = {
        winbar = "%!v:lua.Fyler.getcwd()",
      },
      mappings = {
        n = {
          ["H"] = { action = "shrink", args = { parent = true } },
          ["<C-V>"] = { disabled = true },
          ["_"] = { action = "select", args = { vsplit = true } },
          ["L"] = { action = "select" },
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
      kind_presets = {
        split_left_most = { width = "20%" },
      },
      ui = {
        indent_guides = true,
      },
      use_as_default_explorer = true,
    })
  end,
  keys = {
    { "n", "<leader>ee", function() require("fyler").toggle({ kind = "split_left_most" }) end, { desc = "Fyler" } },
    { "n", "<leader>ef", function() require("fyler").toggle({ kind = "floating" }) end, { desc = "Fyler (floating)" } },
    { "n", "<leader>er", function() require("fyler").toggle({ kind = "split_left_most", root_path = "~" }) end, { desc = "Fyler (root path)" } },
  },
})
