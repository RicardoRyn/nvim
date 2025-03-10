-- 禁用markdownlint-cli2
if vim.g.vscode then
  return {}
else
  return {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {}, -- 禁用markdownlint-cli2
      },
    },
  }
end
