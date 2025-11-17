return {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    options = {
      globalstatus = true,
      component_separators = { left = "", right = ""},
      section_separators = { left = "", right = ""},
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
    },
    sections = {
      lualine_a = { "filename" },
      lualine_b = {
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          "diff",
          symbols = {
            added = require("utils.icons").git.added .. "",
            modified = require("utils.icons").git.modified .. "",
            removed = require("utils.icons").git.deleted .. "",
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        {
          "diagnostics",
          symbols = {
            error = require("utils.icons").diagnostics.error .. "",
            warn = require("utils.icons").diagnostics.warn .. "",
            info = require("utils.icons").diagnostics.info .. "",
            hint = require("utils.icons").diagnostics.hint .. "",
          },
        },
      },
      lualine_c = {
        function()
          return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:h")
        end,
      },
      lualine_x = {
        {
          function()
            return require("noice").api.status.command.get()
          end,
          cond = function()
            return package.loaded["noice"] and require("noice").api.status.command.has()
          end,
        },
        {
          function()
            return require("noice").api.status.mode.get()
          end,
          cond = function()
            return package.loaded["noice"] and require("noice").api.status.mode.has()
          end,
          color = { fg = "#8839ef", gui = "bold" },
        },
        {
          function()
            return "  " .. require("dap").status()
          end,
          cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
          end,
          color = { fg = "#ff0000", gui = "bold" },
        },
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#f38ba8", gui = "bold" },
        },
      },
      lualine_y = {
        { "progress", separator = "", padding = { left = 1, right = 0 } },
        { "location" }
      },
      lualine_z = {
        "searchcount",
        "mode",
      },
    },
    extensions = { "neo-tree", "lazy", "fzf", "avante" },
  },
}
