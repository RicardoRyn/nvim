if vim.g.vscode then
  return
end

-- Don't map inside nvim instances spawned as jj diff/merge editors.
if require("utils.special_mode").is_active() then
  return
end

require("utils.jj_review").setup({
  keymap = "<leader>gs",
})
