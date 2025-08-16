return {
  "folke/persistence.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  event = "BufReadPre",
  opts = {},
    -- stylua: ignore
    keys = {
      { "<localleader>ss", function() require("persistence").load() end, desc = "Restore Session" },
      { "<localleader>sS", function() require("persistence").select() end,desc = "Select Session" },
      { "<localleader>sl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<localleader>sd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
}
