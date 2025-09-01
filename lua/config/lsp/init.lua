-- 把 Mason 安装的工具路径自动加到 Neovim 的 PATH 中，方便插件直接调用这些工具
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. package.config:sub(1, 1) .. vim.env.PATH
end

-- UI
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

-- 功能
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
vim.keymap.set("n", "<leader>cd", function() vim.diagnostic.open_float() end, { desc = "Show Diagnostics (line)" })
vim.keymap.set("n", "<leader>cD", ":Telescope diagnostics bufnr=0<CR>", { desc = "Show Diagnostics (buffer)" })

-- 提示
-- 不显示指定K也可以显示悬浮信息，但是指定了有更多的信息，比如语言名称
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Information" })
-- 函数签名会经过noice渲染，比如在此处指明{ border = "rounded" }，<C-k>才能正确进入该弹窗
vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, { desc = "Show Signature Help" })

-- 跳转 (由snacks实现)
-- vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>", { desc = "Go to Definition" })
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
-- vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>", { desc = "Go to References" })
-- vim.keymap.set("n", "gt", ":Telescope lsp_type_definitions<CR>", { desc = "Go to Type Definition" })
-- vim.keymap.set("n", "gI", ":Telescope lsp_implementations<CR>", { desc = "Go to Implementation" })
