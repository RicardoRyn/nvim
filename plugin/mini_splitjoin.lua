require("mini.misc").safely("later", function()
  require("mini.splitjoin").setup({
    mappings = {
      toggle = "<leader>lm",
      split = "",
      join = "",
    },
  })
end)
