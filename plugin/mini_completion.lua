require("mini.icons").setup()
require("mini.icons").tweak_lsp_kind()

local MiniSnippets = require("mini.snippets")
MiniSnippets.setup({
    snippets = {
        MiniSnippets.gen_loader.from_lang(),
    },
})
MiniSnippets.start_lsp_server()

require("mini.completion").setup()

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
vim.opt.pumblend = 0 -- menu transparency
vim.opt.pumheight = 10 -- max number of items in the popup menu
vim.opt.pumborder = "single"

-- Nvim built-in cmdline complete
vim.opt.wildoptions = "fuzzy,pum"
vim.opt.wildmode = "noselect:lastused"
local cmdline_cmp_group = vim.api.nvim_create_augroup("NativeCmdlineCmp", { clear = true })
vim.api.nvim_create_autocmd("CmdlineChanged", {
  group = cmdline_cmp_group,
  pattern = { ":", "/", "?" },
  callback = function()
    vim.fn.wildtrigger()
  end,
})
