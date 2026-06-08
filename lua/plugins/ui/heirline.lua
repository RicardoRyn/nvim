return {
  "rebelot/heirline.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  config = function()
    local colors = require("utils.heirline.colors")
    local Align = { provider = "%=" }
    local Statusline = require("utils.heirline.statusline")

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
        Statusline.ai,
        Statusline.lsp.LSPActive,
        Statusline.diagnostics,
        Statusline.cursor_position.Ruler,
        Statusline.cursor_position.ScrollBar,
        Statusline.jj.JjLog,
      },
    })
  end,
}
