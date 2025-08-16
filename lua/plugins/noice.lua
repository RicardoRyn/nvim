return {
  "folke/noice.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- 太挡视野了吧，但是可以<leader>nd
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    commands = {
      history = {
        view = "popup",
      },
      last = {
        view = "popup",
      },
      error = {
        view = "popup",
      },
      all = {
        view = "popup",
      },
    },
  },
    -- stylua: ignore
    keys = {
      { "<leader>nm", "<cmd>messages<CR>", desc = "Messages" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "History" },
      { "<leader>ne", function() require("noice").cmd("error") end, desc = "Error" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss" },
      { "<leader>nt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    -- stylua: ignore
    config = function(_, opts)
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
}
