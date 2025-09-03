return {
  -- AI代码补全应该是免费的
  -- 输入`:Codeium Auth`自动跳转到网页，并显示token，然后复制即可使用
  -- 如果没有显示token，事先在浏览器登录windsurf，然后在从neovim中跳转
  "Exafunction/windsurf.nvim",
  cond = not vim.g.vscode,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  build = ":Codeium Auth",
  config = function()
    require("codeium").setup({
      virtual_text = {
        enabled = true,
        key_bindings = {
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
    })
  end,
}
