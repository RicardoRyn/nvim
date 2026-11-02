if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha, auto
    background = {
      light = "latte",
      dark = "mocha",
    },
    auto_integrations = true,
  })

  vim.cmd.colorscheme("catppuccin")
  if vim.o.background == "light" then
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#dddddd" })
  end

  -- Set diff highlights based on the current background
  local diff = vim.o.background == "light"
      and {
        add_fg = "#40a02b",
        add_bg = "#d8efd8",
        del_fg = "#d20f39",
        del_bg = "#f8dcdc",
        chg_fg = "#8a6d1a",
        chg_bg = "#f5ecc8",
        text_bg = "#e9d58a",
      }
    or {
      add_fg = "#a6e3a1",
      add_bg = "#223322",
      del_fg = "#f38ba8",
      del_bg = "#3a252b",
      chg_fg = "#f9e2af",
      chg_bg = "#3a3322",
      text_bg = "#55471f",
    }
  vim.api.nvim_set_hl(0, "DiffAdd", { fg = diff.add_fg, bg = diff.add_bg })
  vim.api.nvim_set_hl(0, "DiffDelete", { fg = diff.del_fg, bg = diff.del_bg })
  vim.api.nvim_set_hl(0, "DiffChange", { fg = diff.chg_fg, bg = diff.chg_bg })
  vim.api.nvim_set_hl(0, "DiffText", { fg = diff.chg_fg, bg = diff.text_bg, bold = true })
  vim.api.nvim_set_hl(0, "DiffTextAdd", { fg = diff.chg_fg, bg = diff.text_bg, bold = true })
end)
