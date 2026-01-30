return {
  "ajbuccin/ipynb.nvim",
  branch = "main",
  dev = true,

  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
    -- "nvim-tree/nvim-web-devicons", -- optional, for language icons
    "folke/snacks.nvim", -- optional, for inline images
  },
  opts = {
    keymaps = {
      -- Navigation (Notebook mode)
      next_cell = "]]", -- jump to next cell
      prev_cell = "[[", -- jump to previous cell
      -- Navigation (both Notebook mode and Cell mode)
      jump_to_cell = "<leader>kj", -- open cell picker
      -- Cell operations (Notebook mode)
      cut_cell = "dd", -- cut cell to register
      paste_cell_below = "p", -- paste cell below
      paste_cell_above = "P", -- paste cell above
      move_cell_down = "<Down>", -- move cell down
      move_cell_up = "<Up>", -- move cell up
      -- Cell operations (both Notebook mode and Cell mode)
      add_cell_above = "<leader>ka", -- insert cell above
      add_cell_below = "<leader>kb", -- insert cell below
      make_markdown = "<leader>km", -- convert to markdown cell
      make_code = "<leader>ky", -- convert to code cell
      make_raw = "<leader>kr", -- convert to raw cell
      fold_toggle = "<leader>kf", -- toggle cell fold
      -- Execution (both Notebook mode and Cell mode)
      execute_cell = "<C-CR>", -- execute cell, stay
      execute_and_next = "<S-CR>", -- execute cell, move to next
      execute_and_insert = "<M-CR>", -- execute cell, insert new below
      execute_all_below = nil, -- execute current and all below (unmapped)
      menu_execute_cell = "<leader>kx", -- execute cell (menu, if <C-CR> conflicts)
      menu_execute_and_next = "<leader>kX", -- execute and next (menu, if <S-CR> conflicts)
      -- Output (both Notebook mode and Cell mode)
      open_output = "<leader>ko", -- open cell output in float (for copying)
      clear_output = "<leader>kc", -- clear current cell output
      clear_all_outputs = "<leader>kC", -- clear all outputs
      -- Kernel (both Notebook mode and Cell mode)
      interrupt_kernel = "<C-c>", -- interrupt execution
      kernel_interrupt = "<leader>ki", -- interrupt (menu)
      kernel_restart = "<leader>k0", -- restart kernel
      kernel_start = "<leader>ks", -- start kernel
      kernel_shutdown = "<leader>kS", -- shutdown kernel
      kernel_info = "<leader>kn", -- show kernel info
      -- Inspector (both Notebook mode and Cell mode)
      variable_inspect = "<leader>kh", -- inspect variable at cursor
      cell_variables = "<leader>kv", -- show all variables in cell
      toggle_auto_hover = "<leader>kH", -- toggle auto-hover on CursorHold
      -- Note: i, a, I, A, o, O, <CR> enter Cell mode; <Esc> exits Cell mode
      -- Note: u, <C-r> perform global undo/redo across cells in both Notebook mode and Cell mode
      -- Note: <C-j>/<C-k> navigate cells while in Cell mode
      -- Note: LSP commands (go to definition, references, hover, etc.) are proxied
    },
  },
}
