vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("marksman")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("texlab")

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  underline = true,
  update_in_insert = true,
  signs = true,
})
vim.g.diagnostics_visible = true

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf

    vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { buffer = buf, desc = "Show signature help" })
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { buffer = buf, desc = "LSP code action" })
    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { buffer = buf, desc = "LSP diagnostics" })
    vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { buffer = buf, desc = "LSP rename" })
    vim.keymap.set("n", "<leader>lx", function() vim.lsp.codelens.run() end, { buffer = buf, desc = "LSP codelens" })
    vim.keymap.set("n", "<leader>lR", function()
      vim.notify("Restarting LSP...", vim.log.levels.INFO)
      vim.cmd("lsp restart")
      vim.notify("LSP restarted", vim.log.levels.INFO)
    end, { buffer = buf, desc = "LSP restart" })
  end,
})
