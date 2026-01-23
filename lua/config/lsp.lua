-- 启动
vim.lsp.enable("lua_ls")
-- vim.lsp.enable("pyright")
vim.lsp.enable("ty")
vim.lsp.enable("ruff")
vim.lsp.enable("bashls")
vim.lsp.enable("rust-analyzer")
vim.lsp.enable("marksman")
vim.lsp.enable("yamlls")
vim.lsp.enable("matlab_ls")

-- UI
vim.g.diagnostics_visible = true
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  signs = false,
  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = require("utils.icons").diagnostics.error,
  --     [vim.diagnostic.severity.WARN] = require("utils.icons").diagnostics.warning,
  --     [vim.diagnostic.severity.INFO] = require("utils.icons").diagnostics.info,
  --     [vim.diagnostic.severity.HINT] = require("utils.icons").diagnostics.hint,
  --   },
  --   numhl = {
  --     [vim.diagnostic.severity.ERROR] = "DiagnosticError",
  --     [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
  --     [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
  --     [vim.diagnostic.severity.HINT] = "DiagnosticHint",
  --   },
  -- },
})

-- 功能
vim.keymap.set("n", "<leader>lsp", function()
  vim.notify("Restart LSP", vim.log.levels.INFO)
  vim.cmd("LspRestart")
end, { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "Show Diagnostics (line)" })
vim.keymap.set("n", "<leader>lD", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show Diagnostics (buffer)" })

-- 提示
vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show Signature Help" })
