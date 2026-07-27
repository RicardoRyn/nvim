if vim.g.vscode then
  return
end

require("mini.misc").safely("event:InsertEnter", function()
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = "<C-y>",
        accept_word = "<C-w>",
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<Esc>",
      },
    },
    -- Handled by sidekick
    nes = { enabled = false },
  })
end)
