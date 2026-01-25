-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local is_light = vim.opt.background:get() == "light"
local flavor = is_light and "catppuccin-latte" or "catppuccin-mocha"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins.ai" },
    { import = "plugins.core" },
    { import = "plugins.dap" },
    { import = "plugins.editor" },
    { import = "plugins.tools" },
    { import = "plugins.ui" },
    { import = "plugins.vcs" },
  },
  dev = {
    path = SYSTEM.is_win and "E:/git_repositories/nvim_dev" or "~/git_repositories/nvim_dev",
    -- fallback: 如果本地找不到这个文件夹，是否去 GitHub 下载
    fallback = true,
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { flavor } },
  -- automatically check for plugin updates
  checker = { enabled = true },
  ui = {
    border = "single",
  },
})
