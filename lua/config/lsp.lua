vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("marksman")
vim.lsp.enable("rust_analyzer")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- UI
    vim.g.diagnostics_visible = true
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = false,
      underline = true,
      update_in_insert = true,
      signs = false,
    })

    -- mapping
    vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show signature help" })
    vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { desc = "LSP code action" })
    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "LSP diagnostics" })
    -- vim.keymap.set("n", "<leader>li", function() vim.lsp.buf.implementation() end, { desc = "LSP implementation" })
    vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { desc = "LSP rename" })
    -- vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { desc = "LSP type" })
    -- vim.keymap.set("n", "<leader>lt", function() vim.lsp.buf.type_definition() end, { desc = "LSP type" })
    vim.keymap.set("n", "<leader>lx", function() vim.lsp.codelens.run() end, { desc = "LSP codelens" })
    -- vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { desc = "LSP references" })
    vim.keymap.set("n", "<leader>lR", function()
      vim.notify("Restarting LSP...", vim.log.levels.INFO)
      vim.cmd("lsp restart")
      vim.notify("LSP restarted", vim.log.levels.INFO)
    end, { desc = "LSP restart" })
  end,
})
