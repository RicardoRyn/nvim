if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("codewindow").setup({
      screen_bounds = "background", -- How the visible area is displayed, "lines": lines above and below, "background": background color
    })
  end,
  -- stylua: ignore
  keys = {
    { "n", "<leader>m", function() require("codewindow").toggle_minimap() end, { desc = "Map" }, },
  },
})
