return {
  "linux-cultist/venv-selector.nvim",
  cond = not vim.g.vscode,
  ft = "python",
  dependencies = { "neovim/nvim-lspconfig" },
  branch = "main", -- This is the regexp branch, use this for the new version
  keys = {
    { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Virtual Env" },
  },
  opts = function()
    local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
    return {
      search = {
        anaconda_base = {
          command = is_windows and "fd python.exe$ E:/python/envs --max-depth 2 --full-path --color never -HI -a -L"
            or "fd /python$ ~/miniforge3/envs --max-depth 3 --full-path --color never -E /proc",
          type = "anaconda",
        },
        cwd = {
          command = is_windows and "fd python.exe$ $CWD/.venv/Scripts --full-path --color never -HI -a -L"
            or "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L",
        },
      },
    }
  end,
}
