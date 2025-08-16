if vim.g.vscode then
  return {}
else
  return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Find Files (recently opened)",
      },
      {
        "<leader>fg",
        function()
          local current_file = vim.api.nvim_buf_get_name(0)
          require("telescope.builtin").live_grep({
            search_dirs = { current_file }, -- 限制范围到当前文件
          })
        end,
        desc = "Live Grep in current buffer",
      },
      {
        "<leader>fG",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find Live Grep (cwd)",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find Files (buffers)",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find Help Tags",
      },
      -- Todo-comments
      {
        "<leader>ftt",
        function()
          local cwd = vim.fn.expand("%:p:h") -- 当前 buffer 所在目录
          vim.cmd("TodoTelescope cwd=" .. cwd)
        end,
        desc = "Find TODOs (buffer directory)",
      },
      {
        "<leader>ftT",
        "<cmd>TodoTelescope<CR>",
        desc = "Find TODOs (cwd)",
      },
      {
        "<leader>ftf",
        function()
          local cwd = vim.fn.expand("%:p:h") -- 当前 buffer 所在目录
          vim.cmd("TodoTelescope keywords=FIX,TODO,HACK,WARN cwd=" .. cwd)
        end,
        desc = "Find FIXs (buffer directory)",
      },
      {
        "<leader>ftF",
        "<cmd>TodoTelescope keywords=FIX,TODO,HACK,WARN<CR>",
        desc = "Find FIXs (cwd)",
      },
    },
  }
end
