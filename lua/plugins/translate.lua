return {
  "uga-rosa/translate.nvim",
  -- stylua: ignore
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>tr', "viw:Translate ZH -output=replace<CR>", { noremap = true, silent = true, desc = "Translate current word (replace)" })
    vim.api.nvim_set_keymap('v', '<leader>tr', ":'<,'>Translate ZH -output=replace<CR>", { noremap = true, silent = true, desc = "Translate selected text (replace)" })
    vim.api.nvim_set_keymap('n', '<leader>tf', "viw:Translate ZH<CR>", { noremap = true, silent = true, desc = "Translate current word" })
    vim.api.nvim_set_keymap('v', '<leader>tf', ":'<,'>Translate ZH<CR>", { noremap = true, silent = true, desc = "Translate selected text" })
    -- require("translate").setup({
    --   default = {
    --     command = "translate_shell",
    --   },
    --   preset = {
    --     command = {
    --       translate_shell = {
    --         args = { "-e", "bing" }
    --       }
    --     }
    --   }
    -- })
  end
,
}
