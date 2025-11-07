return {
  "mfussenegger/nvim-lint",
  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lint").linters_by_ft = {
      -- bash
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      -- markdown
      markdown = { "markdownlint-cli2" },
      -- yaml
      yaml = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
