return {
  "linux-cultist/venv-selector.nvim",
  cond = function()
    return vim.loop.os_uname().sysname == "Linux" and not vim.g.vscode
  end,
  event = "VeryLazy",
  dependencies = {
    "neovim/nvim-lspconfig",
    -- "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-dap-python", --optional
    -- { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  branch = "main", -- This is the regexp branch, use this for the new version
  keys = {
    { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Virtual Env" },
  },
  opts = {
    search = {
      anaconda_base = {
        command = "fd /python$ ~/miniforge3/envs --max-depth 3 --full-path --color never -E /proc",
        type = "anaconda", -- 这里必须是 anaconda，才能生效
      },
      cwd = { command = "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L" },
    },
  },
}
