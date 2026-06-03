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
        Statusline.file_name_block,
        Statusline.file_others,
        Statusline.jj.JjLog,
        Statusline.jj.Diff,
        Align,
        Statusline.work_dir.CurrentDir,
        Align,
        Statusline.cmdline.SelectionCount,
        Statusline.cmdline.MacroRec,
        Statusline.cmdline.SearchCount,
        Statusline.dap_messages,
        Statusline.lazy,
        Statusline.diagnostics,
        Statusline.ai,
        Statusline.lsp.LSPActive,
        Statusline.cursor_position.Ruler,
        Statusline.cursor_position.ScrollBar,
        Statusline.vim_mode,
      },
      tabline = {
        Tabline.tabline_offset,
        Tabline.bufferline,
        Tabline.tabpages,
      },
    })

    vim.keymap.set("n", "<S-h>", function ()
      require("utils.buffer_actions").cycle(-1)
    end, { desc = "Prev Buffer" })
    vim.keymap.set("n", "<S-l>", function ()
      require("utils.buffer_actions").cycle(1)
    end, { desc = "Next Buffer" })
    vim.keymap.set("n", "<leader>ba", function()
      Snacks.bufdelete.all()
    end, { desc = "Delete All Buffers" })
    vim.keymap.set("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Delete Buffer" })
    vim.keymap.set("n", "<leader>bo", function()
      Snacks.bufdelete.other()
    end, { desc = "Delete Other Buffer" })

    vim.keymap.set("n", "<leader>b<", function()
      require("utils.buffer_actions").move(-1)
    end, { desc = "Move buffer left" })
    vim.keymap.set("n", "<leader>b>", function()
      require("utils.buffer_actions").move(1)
    end, { desc = "Move buffer right" })

    vim.keymap.set("n", "<b", function()
      local dir = -1
      local moveBy = vim.v.count > 0 and vim.v.count or 1
      local bm = require("utils.buffer_actions")
      for _ = 1, moveBy do
        bm.move(dir)
      end
    end, { desc = "Move current buffer to left" })

    vim.keymap.set("n", ">b", function()
      local dir = 1
      local moveBy = vim.v.count > 0 and vim.v.count or 1
      local bm = require("utils.buffer_actions")
      for _ = 1, moveBy do
        bm.move(dir)
      end
    end, { desc = "Move current buffer to right" })

    vim.keymap.set("n", "<leader>td", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
    vim.keymap.set("n", "<leader>ts", "<Cmd>tab split<CR>", { desc = "Tab Split" })
    vim.keymap.set("n", "<leader>tn", "<Cmd>tabnew<CR>", { desc = "New Tab" })
  end,
}
