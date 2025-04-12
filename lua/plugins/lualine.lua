if vim.g.vscode then
  return {}
else
  return {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {
          "encoding",
        }
      }
    }
  }
end
