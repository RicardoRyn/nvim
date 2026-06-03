-- 启动
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
-- vim.lsp.enable("ty")
-- vim.lsp.enable("ruff")
vim.lsp.enable("bashls")
vim.lsp.enable("marksman")
vim.lsp.enable("yamlls")
vim.lsp.enable("matlab_ls")
vim.lsp.enable("texlab")

-- UI
vim.g.diagnostics_visible = true
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  signs = false,
})

-- 功能
vim.keymap.set("n", "<leader>lsp", function()
  vim.notify("Restarting LSP...", vim.log.levels.INFO)
  vim.cmd("lsp restart")
  vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>ld", function()
  vim.diagnostic.open_float()
end, { desc = "Show Diagnostics (line)" })

-- 提示
vim.keymap.set("i", "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show Signature Help" })
