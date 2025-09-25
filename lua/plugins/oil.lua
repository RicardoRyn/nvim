return {
  "stevearc/oil.nvim",
  cond = not vim.g.vscode,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  opts = {},
  config = function()
    function _G.get_oil_winbar()
      local dir = require("oil").get_current_dir()
      if dir then
        return vim.fn.fnamemodify(dir, ":~")
      else
        return vim.api.nvim_buf_get_name(0)
      end
    end
    local detail = false

    require("oil").setup({
      delete_to_trash = true,
      keymaps = {
        ["<C-t>"] = false,
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["-"] = false,
        ["<C-c>"] = false,
        ["<leader>e"] = "actions.close",
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-r>"] = "actions.refresh",
        ["<BS>"] = "actions.parent",
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
      },
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
    })
  end,
}
