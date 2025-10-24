return {
  "folke/noice.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    commands = {
      history = { view = "popup" },
      last = { view = "popup" },
      error = { view = "popup" },
      all = { view = "popup" },
    },
    routes = {
      { filter = { event = "msg_show", }, view = "mini", },
    },
  },

  -- stylua: ignore
  keys = {
    { "<leader>n", "<cmd>Noice pick<CR>", desc = "Noice" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss" },
    { "<leader>sne", function() require("noice").cmd("error") end, desc = "Error" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "History" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Last Message" },
    { "<leader>snm", "<cmd>messages<CR>", desc = "Messages" },
  },

  -- stylua: ignore
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
