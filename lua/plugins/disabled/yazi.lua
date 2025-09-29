return {
  "mikavilpas/yazi.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    { "<leader>-", "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
    { "<leader>cw", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Yazi (buffer directory)" },
    { "<leader>=", "<cmd>Yazi toggle<cr>", desc = "Yazi (last session)", } },
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}
