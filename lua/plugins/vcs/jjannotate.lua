return {
  "https://tangled.org/ronshavit.com/jjannotate.nvim",
  cond = not vim.g.vscode,
  keys = {
    {
      "<leader>ja",
      function()
        require("jjannotate").toggle()
      end,
      desc = "JJ annotate file",
    },
  },
}
