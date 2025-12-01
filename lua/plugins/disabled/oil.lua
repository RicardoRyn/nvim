return {
  "stevearc/oil.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
    { "benomahony/oil-git.nvim" },
  },
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Oil" },
    { "-", "<cmd>Oil<cr>", desc = "Oil" },
  },
  opts = {},
  config = function()
    -- 在winbar显示当前路径
    function _G.get_oil_winbar()
      local dir = require("oil").get_current_dir()
      if dir then
        return vim.fn.fnamemodify(dir, ":~")
      else
        return vim.api.nvim_buf_get_name(0)
      end
    end
    -- 显示文件细节
    local detail = false

    require("oil").setup({
      delete_to_trash = true,
      keymaps = {
        -- 禁用默认键位
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        -- 启用默认键位
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
        -- 自定义键位
        ["<BS>"] = "actions.parent",
        ["<leader>e"] = "actions.close",
        ["<leader>cc"] = "actions.yank_entry",
        ["<leader>cr"] = { "actions.yank_entry", opts = { modify = ":." } },
        ["<C-f>"] = "actions.preview_scroll_down",
        ["<C-b>"] = "actions.preview_scroll_up",
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
