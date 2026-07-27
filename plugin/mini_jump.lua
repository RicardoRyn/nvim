require("mini.misc").safely("later", function()
  require("mini.jump").setup({
    mappings = {
      forward = "f",
      backward = "F",
      forward_till = "t",
      backward_till = "T",
      repeat_jump = ";",
    },
    delay = {
      highlight = 0,
    },
  })

  vim.api.nvim_set_hl(0, "MiniJump", { fg = "#ff007c", bold = true })
end)
