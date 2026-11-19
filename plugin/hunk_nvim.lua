if vim.g.vscode then
  return
end

require("utils.lazy").register({
  setup = function()
    require("hunk").setup()
  end,
  cmd = { "DiffEditor", "MergeEditor" },
})
