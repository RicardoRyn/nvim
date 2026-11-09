if vim.g.vscode then
  return
end

if not require("utils.system").is_mac then
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate Left", remap = true })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate Down", remap = true })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate Up", remap = true })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate Right", remap = true })
  return
end

require("mini.misc").safely("now", function()
  require("rex-navigator").setup()
end)
