return {
  "mikesmithgh/kitty-scrollback.nvim",
  cond = not vim.g.vscode and vim.loop.os_uname().sysname ~= "Windows_NT",
  enabled = true,
  lazy = true,
  cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth", "KittyScrollbackGenerateCommandLineEditing" },
  event = { "User KittyScrollbackLaunch" },
  -- version = '*', -- latest stable version, may have breaking changes if major version changed
  -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
  config = function()
    require("kitty-scrollback").setup()
  end,
}
