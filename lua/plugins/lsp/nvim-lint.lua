return {
  "mfussenegger/nvim-lint",
  cond = function()
    return not vim.g.vscode
  end,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lint").linters_by_ft = {
      sh = { "shellcheck" }, -- 为bash脚本添加静态检查
      bash = { "shellcheck" }, -- 为bash脚本添加静态检查

      markdown = { "markdownlint-cli2" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
