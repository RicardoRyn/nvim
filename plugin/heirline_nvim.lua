if vim.g.vscode then return end

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
    Statusline.diff,
    Statusline.cmdline.MacroRec,
    Align,
    Align,
    Statusline.cmdline.SelectionCount,
    Statusline.cmdline.SearchCount,
    Statusline.dap_messages,
    Statusline.python_venv,
    Statusline.ai,
    Statusline.lsp.LSPActive,
    Statusline.diagnostics,
    Statusline.cursor_position.Ruler,
    Statusline.cursor_position.ScrollBar,
    Statusline.jj,
  },
  tabline = {
    Tabline.tabline_offset,
    Tabline.bufferline,
    Tabline.tabpages,
  },
})

vim.keymap.set("n", "<S-h>", function() require("utils.buffer_actions").cycle(-1) end, { desc = "Buffer prev" })
vim.keymap.set("n", "<S-l>", function() require("utils.buffer_actions").cycle(1) end, { desc = "Buffer next" })

vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Buffer delete" })

vim.keymap.set("n", "<leader>ba", function()
  local ba = require("utils.buffer_actions")
  Snacks.bufdelete({ filter = function(b) return not ba.is_pinned(b) end })
end, { desc = "Buffer delete all " })

vim.keymap.set("n", "<leader>bo", function()
  local ba = require("utils.buffer_actions")
  local cur = vim.api.nvim_get_current_buf()
  Snacks.bufdelete({ filter = function(b) return b ~= cur and not ba.is_pinned(b) end })
end, { desc = "Buffer delete other" })

vim.keymap.set("n", "<leader>bp", function() require("utils.buffer_actions").toggle_pin() end, { desc = "Buffer pin toggle" })
vim.keymap.set("n", "<leader>bb", function() require("utils.buffer_actions").pick_close() end, { desc = "Buffer delete pick" })
vim.keymap.set("n", "<leader>bl", function() require("utils.buffer_actions").close_in_direction("left") end, { desc = "Buffer delete left" })
vim.keymap.set("n", "<leader>br", function() require("utils.buffer_actions").close_in_direction("right") end, { desc = "Buffer delete right" })

vim.keymap.set("n", "<leader>b<", function() require("utils.buffer_actions").move(-1) end, { desc = "Buffer move left" })
vim.keymap.set("n", "<leader>b>", function() require("utils.buffer_actions").move(1) end, { desc = "Buffer move right" })

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

vim.keymap.set("n", "<leader>td", "<Cmd>tabclose<CR>", { desc = "Tab delete" })
vim.keymap.set("n", "<leader>ts", "<Cmd>tab split<CR>", { desc = "Tab split" })
vim.keymap.set("n", "<leader>tn", "<Cmd>tabnew<CR>", { desc = "Tab new" })
