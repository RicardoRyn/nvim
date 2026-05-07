local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>la", function()
  vim.cmd.RustLsp("codeAction")
end, { desc = "Rust Code Action", buffer = bufnr, silent = true })
vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp({ "hover", "actions" })
end, { desc = "Rust Hover", buffer = bufnr, silent = true })
