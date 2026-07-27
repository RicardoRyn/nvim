if vim.g.vscode then return end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "jjannotate",
  desc = "Enable listchars for jjannotate",
  callback = vim.schedule_wrap(function() vim.opt_local.list = true end),
})

vim.keymap.set("n", "<leader>ja", function() require("jjannotate").toggle() end, { desc = "JJ annotate" })
