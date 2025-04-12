# nvim中光标动效
if vim.g.vscode then
  return {}
elseif vim.g.neovide then
  return {}
else
  return {
    "sphamba/smear-cursor.nvim",
    opts = {},
  }
end
