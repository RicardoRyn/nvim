if vim.g.vscode then return end

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
