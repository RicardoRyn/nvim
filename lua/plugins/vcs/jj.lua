return {
  "nicolasgb/jj.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim", -- Optional only if you use picker's
  },

  config = function()
    local jj = require("jj")
    jj.setup({
      terminal = {
        cursor_render_delay = 10, -- Adjust if cursor position isn't restoring correctly
      },
      cmd = {
        describe = {
          editor = {
            type = "buffer",
            keymaps = {
              close = { "q", "<Esc>", "<C-c>" },
            }
          }
        },
        bookmark = {
            prefix = "feat/"
        },
        keymaps = {
          log = {
            checkout = "<CR>",
            describe = "<S-d>",
            diff = "d",
            abandon = "<S-a>",
            fetch = "<S-f>",
          },
          status = {
            open_file = "<CR>",
            restore_file = "<S-x>",
          },
          close = { "q", "<Esc>" },
        },
      },
      highlights = {
        -- Customize colors if desired
        modified = { fg = "#89ddff" },
      }
    })

    -- Core commands
    local cmd = require("jj.cmd")
    vim.keymap.set("n", "<leader>jd", cmd.describe, { desc = "JJ describe" })
    vim.keymap.set("n", "<leader>jl", cmd.log, { desc = "JJ log" })
    vim.keymap.set("n", "<leader>jL", "<cmd>J log -r ::<cr>", { desc = "JJ log all" })
    vim.keymap.set("n", "<leader>je", cmd.edit, { desc = "JJ edit" })
    vim.keymap.set("n", "<leader>jn", cmd.new, { desc = "JJ new" })
    vim.keymap.set("n", "<leader>js", cmd.status, { desc = "JJ status" })
    vim.keymap.set("n", "<leader>jS", cmd.squash, { desc = "JJ squash" })
    vim.keymap.set("n", "<leader>ju", cmd.undo, { desc = "JJ undo" })
    vim.keymap.set("n", "<leader>jr", cmd.rebase, { desc = "JJ rebase" })
    vim.keymap.set("n", "<leader>jR", cmd.redo, { desc = "JJ redo" })
    vim.keymap.set("n", "<leader>jbc", cmd.bookmark_create, { desc = "JJ bookmark create" })
    vim.keymap.set("n", "<leader>jbd", cmd.bookmark_delete, { desc = "JJ bookmark delete" })
    vim.keymap.set("n", "<leader>jbm", cmd.bookmark_move, { desc = "JJ bookmark move" })
    vim.keymap.set("n", "<leader>ja", cmd.abandon, { desc = "JJ abandon" })
    vim.keymap.set("n", "<leader>jf", cmd.fetch, { desc = "JJ fetch" })
    vim.keymap.set("n", "<leader>jp", cmd.push, { desc = "JJ push" })

    -- Pickers
    local picker = require("jj.picker")
    vim.keymap.set("n", "<leader>sj", function() picker.status() end, { desc = "JJ Picker status" })
  end,

}
