return {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    options = {
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      },
    },
    sections = {
      lualine_a = {
        "filename",
      },
      lualine_b = {
        {
          function()
            return require("utils.jj_status").get()
          end,
          icon = "",
          color = function()
            return require("utils.jj_status").get_color()
          end,
          cond = function()
            return require("utils.jj_status").get() ~= ""
          end,
        },
        {
          "diff",
          symbols = {
            added = require("utils.icons").git.added,
            modified = require("utils.icons").git.modified,
            removed = require("utils.icons").git.deleted,
          },
          separator = "",
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
      },
      lualine_c = {
        {
          function()
            return " "
          end,
          color = function()
            local status = require("sidekick.status").get()
            if status then
              return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
            end
          end,
          cond = function()
            local status = require("sidekick.status")
            return status.get() ~= nil
          end,
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          function()
            return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:h")
          end,
        },
      },
      lualine_x = {
        -- 操作
        {
          function()
            return require("noice").api.status.command.get()
          end,
          cond = function()
            return package.loaded["noice"] and require("noice").api.status.command.has()
          end,
        },
        -- 搜索信息
        {
          require("noice").api.status.search.get,
          cond = require("noice").api.status.search.has,
        },
        -- 诊断信息
        {
          "diagnostics",
          symbols = {
            error = require("utils.icons").diagnostics.error,
            warn = require("utils.icons").diagnostics.warn,
            info = require("utils.icons").diagnostics.info,
            hint = require("utils.icons").diagnostics.hint,
          },
        },
        {"lsp_status"},
        -- Record状态
        {
          function()
            return require("noice").api.status.mode.get()
          end,
          cond = function()
            return package.loaded["noice"] and require("noice").api.status.mode.has()
          end,
          color = { fg = "#8839ef", gui = "bold" },
        },
        -- DAP状态
        {
          function()
            return "  " .. require("dap").status()
          end,
          cond = function()
            return package.loaded["dap"] and require("dap").status() ~= ""
          end,
          color = { fg = "#ff0000", gui = "bold" },
        },
        -- lazy.nvim更新状态
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#f38ba8", gui = "bold" },
        },
        -- sidekick CLI状态
        {
          function()
            local status = require("sidekick.status").cli()
            return " " .. (#status > 1 and #status or "")
          end,
          cond = function()
            return #require("sidekick.status").cli() > 0
          end,
          color = function()
            return "Special"
          end,
        },
        -- ipynb内核
        {
          require("ipynb.kernel").statusline,
          cond = require("ipynb.kernel").statusline_visible,
          color = require("ipynb.kernel").statusline_color,
        },
      },
      lualine_y = {
        { "progress", separator = "", padding = { left = 1, right = 0 } },
        { "location" },
      },
      lualine_z = {
        "mode",
      },
    },
    extensions = { "neo-tree", "lazy", "fzf", "avante" },
  },
}
