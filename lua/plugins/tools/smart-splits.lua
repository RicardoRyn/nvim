return {
  "mrjones2014/smart-splits.nvim",
  cond = not vim.g.vscode,
  dependencies = { "hiasr/vim-zellij-navigator.nvim" },
  opts = {},
  config = function(_, opts)
    require("smart-splits").setup(opts)

    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left)
    vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down)
    vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up)
    vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right)
    -- moving between splits
    vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
    vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
    vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
    vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
    vim.keymap.set("n", "<C-\\>", require("smart-splits").move_cursor_previous)
    -- swapping buffers between windows
    vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
    vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
    vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
    vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
  end,
}
