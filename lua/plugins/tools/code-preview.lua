return {
  "Cannon07/code-preview.nvim",
  cond = not vim.g.vscode and not SYSTEM.is_win,
  event = "VeryLazy",
  config = function()
    require("code-preview").setup({
      diff = {
        layout = "tab",
      },
      highlights = {
        current = { -- CURRENT (original) side — tab/vsplit layouts
          DiffAdd = { bg = "#d0e2d1" },
          DiffDelete = { bg = "#eac8d3" },
          DiffChange = { bg = "#e0e7f5" },
          DiffText = { bg = "#b0c7f5" },
        },
        proposed = { -- PROPOSED side — tab/vsplit layouts
          DiffAdd = { bg = "#d0e2d1" },
          DiffDelete = { bg = "#eac8d3" },
          DiffChange = { bg = "#e0e7f5" },
          DiffText = { bg = "#b0c7f5" },
        },
        inline = { -- inline layout
          added = { bg = "#d0e2d1" }, -- added line background
          removed = { bg = "#eac8d3" }, -- removed line background
          added_text = { bg = "#e0e7f5" }, -- changed characters (added)
          removed_text = { bg = "#e0e7f5" }, -- changed characters (removed)
        },
      },
    })
  end,
}
