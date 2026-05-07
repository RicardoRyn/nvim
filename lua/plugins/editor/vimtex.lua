return {
  "lervag/vimtex",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- Use SumatraPDF for Windows (supports inverse search)
    vim.g.vimtex_view_method = "general"
    vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
    vim.g.vimtex_view_general_options = "-forward-search @tex @line @pdf"
  end
}
