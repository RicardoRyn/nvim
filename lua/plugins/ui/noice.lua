return {
  "folke/noice.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  dependencies = {
    { "MunifTanjim/nui.nvim" },
  },
  -- stylua: ignore
  keys = {
    { "<leader>un", function() require("noice").cmd("dismiss") end, desc = "Noice Dismiss" },
    { "<leader>nn", function() require("noice").cmd("pick") end, desc = "Noice Picker" },
    { "<leader>na", function() require("noice").cmd("all") end, desc = "All" },
    { "<leader>ne", function() require("noice").cmd("errors") end, desc = "Error" },
    { "<leader>nh", function() require("noice").cmd("history") end, desc = "History" },
    { "<leader>nl", function() require("noice").cmd("last") end, desc = "Last Message" },
    { "<leader>nm", "<cmd>messages<CR>", desc = "Messages" },
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    {"<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, mode = { "n", "i", "s" }, silent = true, expr = true },
    {"<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, mode = { "n", "i", "s" }, silent = true, expr = true },
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
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
        -- notify | mini | popup | cmdline_output | split | vsplit | hover
        view = "mini",
      },
      {
        filter = {
          event = "notify",
          find = "Config Change Detected",
        },
        view = "mini",
      },
      {
        filter = {
          event = "notify",
          find = "adapter `python`.*exited with 1",
        },
        view = "mini",
      },
    },
    commands = {
      history = { view = "popup" },
      last = { view = "popup" },
      errors = { view = "popup" },
      all = { view = "popup" },
    },
  },
  config = function(_, opts)
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
}
