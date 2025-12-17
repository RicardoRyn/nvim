return {
  "julienvincent/hunk.nvim",
  cmd = { "DiffEditor" },
  config = function()
    require("hunk").setup({
      ui = {
        tree = {
          mode = "flat",
        },
      },
    })
  end,
}
