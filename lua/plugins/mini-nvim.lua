return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup() -- 识别小/中/大括号
    require("mini.pairs").setup()
    require("mini.bracketed").setup()
    require("mini.surround").setup({
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        replace = "gsr", -- Replace surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    })

    if not vim.g.vscode then
      require("mini.cursorword").setup()
      -- require("mini.starter").setup()
      -- require("mini.trailspace").setup()
      require("mini.icons").setup()
      vim.keymap.set("n", "<leader>uz", function()
        require("mini.misc").zoom()
      end, { desc = "Zoom (current window)" })

    end
  end,

  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
