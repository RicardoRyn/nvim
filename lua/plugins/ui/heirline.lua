return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local colors = require("utils.heirline.colors")
    local Align = { provider = "%=" }

    local Statusline = require("utils.heirline.statusline")

    require("heirline").setup({
      opts = {
        colors = colors,
      },
      statusline = {
        Statusline.file_name_block,
        Statusline.file_others.FileIcon,
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
    })
  end,
}
