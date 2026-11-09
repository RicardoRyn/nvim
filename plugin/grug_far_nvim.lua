if vim.g.vscode then
  return
end

require("utils.lazy").safely({
  setup = function()
    require("grug-far").setup()
  end,
  keys = {
    { "n", "<localleader>r", "<cmd>GrugFar<cr>", { desc = "Grug Far" } },
  },
})
