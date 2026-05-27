return {
  "dmtrKovalenko/fff.nvim",
  cond = not vim.g.vscode,
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  -- stylua: ignore
  keys = {
    { "<leader><space>", function() require("fff").find_files() end, desc = "FFFind files", },
    -- { "<leader>ff", function() require("fff").find_files() end, desc = "FFFind files", },
    -- { "<leader>fc", function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end, desc = "FFFind config files", },
    -- { "<leader>//", function() require("fff").live_grep() end, desc = "LiFFFe grep", },
    -- { "<leader>/w", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end, desc = "Search current word", },
  },
  opts = {
    layout = {
      prompt_position = "top",
    },
    debug = {
      enabled = true,
      show_scores = true,
    },
    git = {
      status_text_color = true,
    },
  },
}
