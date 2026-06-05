return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  config = function()
    local colors = require("utils.heirline.colors")
    local Align = { provider = "%=" }

    local Statusline = require("utils.heirline.statusline")
    local Tabline = require("utils.heirline.tabline")

    require("heirline").setup({
      opts = {
        colors = colors,
      },
      statusline = {
        Statusline.vim_mode,
        Statusline.work_dir.CurrentDir,
        Statusline.file_others,
        Statusline.file_name_block,
        Statusline.jj.Diff,
        Statusline.cmdline.MacroRec,
        Align,
        Align,
        Statusline.cmdline.SelectionCount,
        Statusline.cmdline.SearchCount,
        Statusline.dap_messages,
        Statusline.lazy,
        Statusline.diagnostics,
        Statusline.ai,
        Statusline.lsp.LSPActive,
        Statusline.cursor_position.Ruler,
        Statusline.cursor_position.ScrollBar,
        Statusline.jj.JjLog,
      },
      tabline = {
        Tabline.tabline_offset,
        Tabline.bufferline,
        Tabline.tabpages,
      },
    })

    vim.keymap.set("n", "<S-h>", function()
      require("utils.buffer_actions").cycle(-1)
    end, { desc = "Buffer prev" })
    vim.keymap.set("n", "<S-l>", function()
      require("utils.buffer_actions").cycle(1)
    end, { desc = "Buffer next" })
    vim.keymap.set("n", "<leader>ba", function()
      Snacks.bufdelete.all()
    end, { desc = "Buffers delete all " })
    vim.keymap.set("n", "<leader>bb", function()
      require("utils.buffer_actions").pick_close()
    end, { desc = "Buffer pick close" })
    vim.keymap.set("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "buffer delete" })
    vim.keymap.set("n", "<leader>bo", function()
      Snacks.bufdelete.other()
    end, { desc = "Buffer delete other" })
    vim.keymap.set("n", "<leader>bl", function()
      require("utils.buffer_actions").close_in_direction("left")
    end, { desc = "Close Buffers to the Left" })
    vim.keymap.set("n", "<leader>br", function()
      require("utils.buffer_actions").close_in_direction("right")
    end, { desc = "Close Buffers to the Right" })
    vim.keymap.set("n", "<leader>b<", function()
      require("utils.buffer_actions").move(-1)
    end, { desc = "Move buffer left" })
    vim.keymap.set("n", "<leader>b>", function()
      require("utils.buffer_actions").move(1)
    end, { desc = "Move buffer right" })

    vim.keymap.set("n", "<b", function()
      local dir = -1
      local moveBy = vim.v.count > 0 and vim.v.count or 1
      local ba = require("utils.buffer_actions")
      for _ = 1, moveBy do
        ba.move(dir)
      end
    end, { desc = "Move current buffer to left" })

    vim.keymap.set("n", ">b", function()
      local dir = 1
      local moveBy = vim.v.count > 0 and vim.v.count or 1
      local ba = require("utils.buffer_actions")
      for _ = 1, moveBy do
        ba.move(dir)
      end
    end, { desc = "Move current buffer to right" })

    vim.keymap.set("n", "<leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
    vim.keymap.set("n", "<leader>ts", "<Cmd>tab split<CR>", { desc = "Tab Split" })
    vim.keymap.set("n", "<leader>tn", "<Cmd>tabnew<CR>", { desc = "New Tab" })
  end,
}
