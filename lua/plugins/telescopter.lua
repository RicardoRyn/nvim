return {
  "nvim-telescope/telescope.nvim",
  cond = not vim.g.vscode,
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- stylua: ignore
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files (cwd)", },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Find Files (recently opened)", },
    { "<leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config", },
    { "<leader>fg",
      function()
        local current_file = vim.api.nvim_buf_get_name(0)
        require("telescope.builtin").live_grep({
          search_dirs = { current_file },
        })
      end,
      desc = "Live Grep in current buffer", },
    { "<leader>fG", function() require("telescope.builtin").live_grep() end, desc = "Find Live Grep (cwd)", },
    { "<leader>fw", function() require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") }) end, desc = "Find Word Under Cursor" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find Files (buffers)", },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find Help Tags", },
    -- Todo-comments
    { "<leader>ftt", function() local cwd = vim.fn.expand("%:p:h") vim.cmd("TodoTelescope cwd=" .. cwd) end, desc = "Find TODOs (buffer directory)", },
    { "<leader>ftT", "<cmd>TodoTelescope<CR>", desc = "Find TODOs (cwd)", },
    { "<leader>ftf", function() local cwd = vim.fn.expand("%:p:h") vim.cmd("TodoTelescope keywords=FIX,TODO,HACK,WARN cwd=" .. cwd) end, desc = "Find FIXs (buffer directory)", },
    { "<leader>ftF", "<cmd>TodoTelescope keywords=FIX,TODO,HACK,WARN<CR>", desc = "Find FIXs (cwd)", },
  },
}
