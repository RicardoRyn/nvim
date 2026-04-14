local function open_lazy_home()
  local ok, lazy = pcall(require, "lazy")
  if not ok or type(lazy.home) ~= "function" then
    vim.notify("lazy.nvim is not available", vim.log.levels.ERROR)
    return
  end
  lazy.home()
end

local M = {
  enabled = true,
  preset = {
    -- stylua: ignore
    keys = {
      { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
      { icon = " ", key = "f", desc = "Find Files", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = " ", key = "w", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
      { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
      { icon = "󰑓 ", key = "s", desc = "Session", section = "session" },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", },
      { icon = "󰒲 ", key = "l", desc = "Lazy", action = open_lazy_home, enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "b", desc = "Browse Repo", action = ":lua Snacks.gitbrowse()" },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    header = false,
  },
  sections = {
    {
      section = "header",
      function()
        return { header = require("utils.dashboard_animation").asciiImg }
      end,
      padding = 1,
    },
    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    { title = "Talk is cheap. Show me the code.", align = "center", padding = 1 },
  },
}

return M
