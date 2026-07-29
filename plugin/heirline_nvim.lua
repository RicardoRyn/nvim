if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
  local colors = require("utils.heirline.colors")
  local align = { provider = "%=" }
  local separator = { provider = "▏", hl = { fg = colors.gray, bg = colors.background  } }
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
      align,
      align,
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
      separator,
      Tabline.bufferline,
    },
  })
end)
