if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  require("mini.icons").setup()
  require("mini.icons").tweak_lsp_kind()

  local MiniSnippets = require("mini.snippets")
  MiniSnippets.setup({
    snippets = {
      MiniSnippets.gen_loader.from_lang(),
    },
  })
  MiniSnippets.start_lsp_server()
  local augroup = vim.api.nvim_create_augroup("SetupMiniSnippets", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "MiniSnippetsSessionJump",
    callback = function(args)
      if args.data.tabstop_to == "0" then
        MiniSnippets.session.stop()
      end
    end,
  })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
      local clear =
        { underline = false, underdouble = false, undercurl = false, underdashed = false, underdotted = false }
      vim.api.nvim_set_hl(0, "MiniSnippetsCurrent", clear)
      vim.api.nvim_set_hl(0, "MiniSnippetsCurrentReplace", clear)
      vim.api.nvim_set_hl(0, "MiniSnippetsFinal", clear)
      vim.api.nvim_set_hl(0, "MiniSnippetsUnvisited", clear)
      vim.api.nvim_set_hl(0, "MiniSnippetsVisited", clear)
    end,
  })
  local snippet_insert = function(snippet_body)
    MiniSnippets.default_insert({ body = snippet_body }, { empty_tabstop = "", empty_tabstop_final = "" })
  end
  require("mini.completion").setup({
    lsp_completion = { snippet_insert = snippet_insert },
  })
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

-- -- Nvim built-in cmdline complete
-- vim.opt.wildoptions = "fuzzy,pum"
-- vim.opt.wildmode = "noselect:lastused"
-- vim.api.nvim_create_autocmd("CmdlineChanged", {
--   group = vim.api.nvim_create_augroup("SetupNativeCmdlineCmp", { clear = true }),
--   pattern = { ":", "/", "?" },
--   callback = function()
--     vim.fn.wildtrigger()
--   end,
-- })
