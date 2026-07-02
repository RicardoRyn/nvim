require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    min_width = 80,
    right_pad = 1,
    border = "thin",
    position = "right",
    highlight_inline = "rendermarkdowncodeinfo",
  },
  heading = {
    sign = false,
    icons = {},
    border = true,
    render_modes = true,
  },
  anti_conceal = {
    enabled = true,
    disabled_modes = { "n" },
  },
  latex = { enabled = false },
})
