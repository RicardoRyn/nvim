return {
  -- 需要事先通过sudo apt install imagemagick安装magick_cli
  "3rd/image.nvim",
  cond = not vim.g.vscode and not SYSTEM.is_win,
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  opts = {
    backend = "kitty", -- Kitty will provide the best experience, but you need a compatible terminal
    integrations = {}, -- do whatever you want with image.nvim's integrations
    max_width = 100, -- tweak to preference
    max_height = 12, -- ^
    max_height_window_percentage = math.huge, -- this is necessary for a good experience
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
}
