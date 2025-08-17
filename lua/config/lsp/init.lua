local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. package.config:sub(1,1) .. vim.env.PATH
end

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  root_markers = { ".git" },
})

-- UI
vim.g.diagnostics_visible = true
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = require("config.icons").diagnostics.error,
      [vim.diagnostic.severity.WARN] = require("config.icons").diagnostics.warning,
      [vim.diagnostic.severity.INFO] = require("config.icons").diagnostics.info,
      [vim.diagnostic.severity.HINT] = require("config.icons").diagnostics.hint,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    },
  },
})
vim.keymap.set("n", "<leader>ux", function()
  vim.g.diagnostics_visible = not vim.g.diagnostics_visible
  if vim.g.diagnostics_visible then
    vim.diagnostic.enable()
    vim.diagnostic.config({
      virtual_text = true,
      underline = true,
      update_in_insert = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = require("config.icons").diagnostics.error,
          [vim.diagnostic.severity.WARN] = require("config.icons").diagnostics.warning,
          [vim.diagnostic.severity.INFO] = require("config.icons").diagnostics.info,
          [vim.diagnostic.severity.HINT] = require("config.icons").diagnostics.hint,
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticError",
          [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
      },
    })
    print("󰂚 Diagnostics Enabled")
  else
    vim.diagnostic.disable()
    vim.diagnostic.config({
      virtual_text = false,
      underline = false,
      signs = false,
    })
    print("󱏧 Diagnostics Disabled")
  end
end, { desc = "Toggle Diagnostics" })

-- stylua: ignore
-- 功能
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cd", function() vim.diagnostic.open_float(nil, { border = "rounded" }) end, { desc = "Show Diagnostics (line)" })
vim.keymap.set("n", "<leader>cD", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show Diagnostics (buffer)" })
-- 跳转
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { desc = "Go to Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", { desc = "Go to References" })
vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>", { desc = "Go to Type Definition" })
vim.keymap.set("n", "gI", ":Telescope lsp_implementations<CR>", { desc = "Go to Implementation" })
-- 提示
-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Information" })
vim.keymap.set({ "i" }, "<C-k>", vim.lsp.buf.signature_help, { desc = "Show Signature Help" })
vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { desc = "Show Signature Help" })
