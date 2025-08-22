return {
  "nvim-lualine/lualine.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = require("utils.icons").diagnostics.error .. " ",
              warn = require("utils.icons").diagnostics.warn .. " ",
              info = require("utils.icons").diagnostics.info .. " ",
              hint = require("utils.icons").diagnostics.hint .. " ",
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            -- stylua: ignore
            function() return vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~") end,
        },
        lualine_x = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = { fg = "#8839ef", gui = "bold" },
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = { fg = "#ff0000", gui = "bold" },
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#f38ba8", gui = "bold" },
          },
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
        },
        lualine_y = {
          {
            function()
              local status = require("codeium.virtual_text").status()
              if status.state == "idle" then
                -- Output was cleared, for example when leaving insert mode
                return "󱙺 Ready"
              end
              if status.state == "waiting" then
                -- Waiting for response
                return "󱚠 Waiting..."
              end
              if status.state == "completions" and status.total > 0 then
                return string.format("󱚤 : %d/%d", status.current, status.total)
              end
              return " 󱚢 Error "
            end,
            color = { fg = "#00afff", gui = "bold" },
          },
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          "encoding",
          function()
            local ok, kernels = pcall(require, "molten.status")
            if ok and kernels.kernels then
              return kernels.kernels()
            end
            return ""
          end,
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    return opts
  end,
}
