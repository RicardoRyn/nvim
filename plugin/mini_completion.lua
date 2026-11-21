if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  require("mini.cmdline").setup({
    autocorrect = {
      enable = false,
    },
  })
  vim.opt.pumblend = 0 -- menu transparency
  vim.opt.pumheight = 10 -- max number of items in the popup menu
  vim.opt.pumborder = "single"
  vim.keymap.set("c", "<Up>", "<C-p>")
  vim.keymap.set("c", "<Down>", "<C-n>")
end)

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("SetupFileCompletion", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or vim.bo[args.buf].filetype == "" then
      return
    end
    local ready = false
    require("mini.misc").safely("now", function()
      require("config.completion").ensure_completion()
      ready = true
    end)
    return ready
  end,
})

-- --------------------------------------------------------------------------------
-- -- Nvim built-in complete
-- --------------------------------------------------------------------------------
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
-- --------------------------------------------------------------------------------
-- -- Nvim built-in cmdline complete
-- --------------------------------------------------------------------------------
-- vim.opt.wildoptions = "fuzzy,pum"
-- vim.opt.wildmode = "noselect:lastused"
-- vim.api.nvim_create_autocmd("CmdlineChanged", {
--   group = vim.api.nvim_create_augroup("SetupNativeCmdlineCmp", { clear = true }),
--   pattern = { ":", "/", "?" },
--   callback = function()
--     vim.fn.wildtrigger()
--   end,
-- })
