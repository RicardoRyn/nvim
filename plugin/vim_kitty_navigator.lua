if vim.g.vscode then
  return
end

vim.keymap.set("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>KittyNavigateDown<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>KittyNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>KittyNavigateRight<cr>")
