return {
  "lewis6991/gitsigns.nvim",
  cond = not vim.g.vscode,
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  opts = {
    signs = {
      add = { text = "▒" },
      change = { text = "▒" },
      delete = { text = "▒" },
      topdelete = { text = "▒" },
      changedelete = { text = "▒" },
      untracked = { text = "▒" },
    },
    signs_staged = {
      add = { text = "┃" },
      change = { text = "┃" },
      delete = { text = "┃" },
      topdelete = { text = "┃" },
      changedelete = { text = "┃" },
      untracked = { text = "┃" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end
      -- 在 o（操作符等待）或 x（可视）模式下，按 ih 就能选中当前 Git hunk（改动块），方便操作（比如 d 删除、y 复制）
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      -- navigation
      map("n", "]g", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Git Hunk")
      map("n", "gh", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Git Hunk")
      map("n", "[g", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Git Hunk")
      map("n", "gH", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Git Hunk")
      map("n", "]G", function()
        gs.nav_hunk("last")
      end, "Last Hunk")
      map("n", "[G", function()
        gs.nav_hunk("first")
      end, "First Hunk")
      -- blame
      map("n", "<leader>gb", function()
        gs.blame_line({ full = true })
      end, "Blame Line")
      map("n", "<leader>gB", function()
        gs.blame()
      end, "Blame Buffer")
      -- diff
      map("n", "<leader>gd", gs.diffthis, "Diff This") -- 当前:暂存区
      map("n", "<leader>gD", function()
        gs.diffthis("~")
      end, "Diff This ~") -- 当前:上一个commit
      -- preview
      map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Hunk")
      map("n", "<leader>gP", gs.preview_hunk, "Preview Hunk Float")
      -- reset
      map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
      -- Toggles
      map('n', '<leader>gt', gs.toggle_current_line_blame, "Toggle Current Line Blame")
      map('n', '<leader>gw', gs.toggle_word_diff, "Toggle Word Diff")

      -- -- stage hunk
      -- map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      -- map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
      -- -- undo stage hunk
      -- map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
      -- map("n", "<leader>gU", gs.undo_stage_hunk, "Undo Stage Buffer")
    end,
  },
}
