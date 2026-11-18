if vim.g.vscode then
  return
end

if not require("utils.system").is_win then
  return
end

vim.keymap.set("n", "<leader>gs", "<cmd>JJSquashHunk<cr>", { desc = "Squash hunk" })
vim.keymap.set("x", "<leader>gs", ":JJSquashHunk<cr>", { desc = "Squash selection" })
