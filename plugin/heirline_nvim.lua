if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
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
      Tabline.tabpages,
      -- TODO: 优化写法
      { provider = "▏", hl = { fg = colors.background, bg = colors.background } },
      Tabline.bufferline,
    },
  })
end)
