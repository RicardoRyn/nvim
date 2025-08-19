return {
  "nvim-zh/colorful-winsep.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  config = true,
  event = { "WinLeave" },
  opts = {
    -- choose between "signle", "rounded", "bold" and "double".
    -- Or pass a tbale like this: { "─", "│", "┌", "┐", "└", "┘" },
    border = "rounded",
    excluded_ft = { "packer", "TelescopePrompt", "mason" },
    highlight = { fg = "#1e66f5" },
    animate = {
      enabled = "shift", -- false to disable, or choose a option below (e.g. "shift") and set option for it if needed
      shift = {
        delta_time = 0.1,
        smooth_speed = 2,
        delay = 1,
      },
      progressive = {
        -- animation's speed for different direction
        vertical_delay = 20,
        horizontal_delay = 2,
      },
    },
    indicator_for_2wins = {
      -- only work when the total of windows is two
      position = "center", -- false to disable or choose between "center", "start", "end" and "both"
      symbols = {
        -- the meaning of left, down ,up, right is the position of separator
        start_left = "󱞬",
        end_left = "󱞪",
        start_down = "󱞾",
        end_down = "󱟀",
        start_up = "󱞢",
        end_up = "󱞤",
        start_right = "󱞨",
        end_right = "󱞦",
      },
    },
  },
}
