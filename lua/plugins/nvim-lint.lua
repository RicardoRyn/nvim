return {
  "mfussenegger/nvim-lint",
  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lint").linters_by_ft = {
      -- NOTE: BASH
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      -- NOTE: MARKDOWN
      markdown = { "markdownlint-cli2" },
      -- NOTE: YAML
      yaml = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
