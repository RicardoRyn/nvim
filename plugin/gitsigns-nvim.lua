if vim.g.vscode then return end

require("gitsigns").setup({
  signs = {
    add = { text = "▒" },
    change = { text = "▒" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged_enable = true,
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  blame_formatter = nil, -- Use default
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

    -- Selection
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    -- Navigation
    map("n", "]g", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next hunk")
    map("n", "gh", function() if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end end, "Next hunk")
    map("n", "[g", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev hunk")
    map("n", "gH", function() if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end end, "Prev hunk")
    map("n", "]G", function() gs.nav_hunk("last") end, "Last hunk")
    map("n", "[G", function() gs.nav_hunk("first") end, "First hunk")
    -- Blame
    map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
    -- map("n", "<leader>gB", function() gs.blame() end, "Blame Buffer")
    -- Preview
    map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
    map("n", "<leader>gP", gs.preview_hunk, "Preview hunk (float)")
    -- Reset
    map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
    -- Toggles
    map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle blame line")
    map("n", "<leader>gw", gs.toggle_word_diff, "Toggle word diff")

    -- -- Diff
    -- map("n", "<leader>gd", gs.diffthis, "Diff (Current Buffer)") -- 当前:暂存区
    -- map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~") -- 当前:上一个commit
    -- -- Stage
    -- map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    -- map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
    -- -- Undo stage
    -- map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
    -- map("n", "<leader>gU", gs.undo_stage_hunk, "Undo Stage Buffer")
  end,
})
