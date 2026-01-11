return {
  "mfussenegger/nvim-lint",
  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("lint").linters_by_ft = {
      -- PYTHON
      python = { "ruff" },
      -- MARKDOWN
      markdown = { "markdownlint-cli2" },
      -- YAML
      yaml = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
