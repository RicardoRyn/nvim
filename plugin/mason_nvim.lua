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
  "marksman", -- LSP (语法高亮、补全、跳转)
  "prettierd", -- 格式化
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

    -- -- Nvim built-in complete
    -- vim.opt.completeopt = { "fuzzy", "menuone", "noselect", "popup" }
    -- vim.opt.complete:append("o")
    -- vim.api.nvim_create_autocmd({ "BufEnter", "InsertEnter", "FileType" }, {
    --   group = vim.api.nvim_create_augroup("AutocompleteFilter", { clear = true }),
    --   callback = function()
    --     local buftype = vim.bo.buftype
    --     local filetype = vim.bo.filetype
    --     if buftype == "prompt" or buftype == "nofile" or filetype == "snacks_picker_input" then
    --       vim.o.autocomplete = false
    --     else
    --       vim.o.autocomplete = true
    --     end
    --   end,
    -- })
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- if client:supports_method("textDocument/completion") and vim.lsp.completion then
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end
    -- vim.opt.pumblend = 0 -- menu transparency
    -- vim.opt.pumheight = 10 -- max number of items in the popup menu
    -- vim.opt.pumborder = "single"

    -- -- Nvim built-in cmdline complete
    -- vim.opt.wildoptions = "fuzzy,pum"
    -- vim.opt.wildmode = "noselect:lastused"
    -- local cmdline_cmp_group = vim.api.nvim_create_augroup("NativeCmdlineCmp", { clear = true })
    -- vim.api.nvim_create_autocmd("CmdlineChanged", {
    --   group = cmdline_cmp_group,
    --   pattern = { ":", "/", "?" },
    --   callback = function()
    --     vim.fn.wildtrigger()
    --   end,
    -- })

    -- mapping
    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "LSP diagnostics" })
    vim.keymap.set("n", "<leader>lr", function()
      vim.notify("Restarting LSP...", vim.log.levels.INFO)
      vim.cmd("lsp restart")
      vim.notify("LSP restarted", vim.log.levels.INFO)
    end, { desc = "LSP restart" })
    vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { desc = "Show signature help" })
  end,
})
