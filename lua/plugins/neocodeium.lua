return {
  "monkoose/neocodeium",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    silent = true,
  },
  -- stylua: ignore
  keys = {
    { "<C-y>", function() require("neocodeium").accept() end, mode = "i" },
    { "<C-w>", function() require("neocodeium").accept_word() end, mode = "i" },
    { "<A-[>", function() require("neocodeium").cycle() end, mode = "i" },
    { "<A-]>", function() require("neocodeium").cycle() end, mode = "i" },
  },
}
