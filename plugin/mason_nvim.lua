if vim.g.vscode then return end

local my_languages = {
  -- lua
  "lua-language-server",
  "stylua",
  -- python
  "pyright",
  "debugpy",
  "ruff",
  -- bash
  "bash-language-server",
  "shellcheck",
  "shfmt",
  "bash-debug-adapter",
  -- rust
  "rust-analyzer",
  "codelldb",
  -- MARKDOWN
  "marksman",
  "prettierd",
}

require("mason").setup({ ensure_installed = my_languages })

local mr = require("mason-registry")

local function ensure_installed()
  for _, tool in ipairs(my_languages) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end

if mr.refresh then
  mr.refresh(ensure_installed)
else
  ensure_installed()
end

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("bashls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("marksman")

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
