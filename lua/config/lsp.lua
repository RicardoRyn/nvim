------------------ LSP！启动！ ------------------
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("marksman")
vim.lsp.enable("rust-analyzer")

------------------ UI ------------------
vim.g.diagnostics_visible = true
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("utils.icons").diagnostics.error,
      [vim.diagnostic.severity.WARN] = require("utils.icons").diagnostics.warning,
      [vim.diagnostic.severity.INFO] = require("utils.icons").diagnostics.info,
      [vim.diagnostic.severity.HINT] = require("utils.icons").diagnostics.hint,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})

------------------ 功能 ------------------
vim.keymap.set("n", "<leader>r", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Show Diagnostics (line)" })
vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show Signature Help" })
