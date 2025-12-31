return {
  "linux-cultist/venv-selector.nvim",
  cond = not vim.g.vscode,
  ft = "python",
  dependencies = { "neovim/nvim-lspconfig" },
  branch = "main", -- This is the regexp branch, use this for the new version
  keys = {
    { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Virtual Env" },
  },
  config = function()
    -- Store original vim.notify before venv-selector loads
    local original_notify = vim.notify

    require("venv-selector").setup({
      search = {
        anaconda_base = {
          command = SYSTEM.is_win and "fd python.exe$ E:/python/envs --max-depth 2 --full-path --color never -HI -a -L"
            or "fd /python$ ~/miniforge3/envs --max-depth 3 --full-path --color never -E /proc",
          type = "anaconda",
        },
        cwd = {
          command = SYSTEM.is_win and "fd python.exe$ $CWD/.venv/Scripts --full-path --color never -HI -a -L"
            or "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L",
        },
      },
    })
    -- Restore vim.notify after venv-selector setup (it overrides in init.lua)
    vim.schedule(function()
      if type(vim.notify) ~= "function" and type(original_notify) == "function" then
        vim.notify = original_notify
      end
    end)
  end,
}
