local M = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == "sidekick_terminal" then
      self.title = "  Sidekick"
      return true
    elseif vim.bo[bufnr].filetype == "snacks_layout_box" then
      self.title = "󰙅  Explorer"
      return true
    elseif vim.bo[bufnr].filetype == "fyler_finder" then
      self.title = "󰙅  Fyler"
      return true
    elseif vim.bo[bufnr].filetype == "snacks_terminal" then
      self.title = "󱥰 Snacks Terminal"
      return true
    elseif vim.bo[bufnr].filetype == "dapui_stacks" then
      self.title = "  Debug UI"
      return true
    elseif vim.bo[bufnr].filetype == "dapui_scopes" then
      self.title = "  Debug UI"
      return true
    elseif vim.bo[bufnr].filetype == "dapui_watches" then
      self.title = "  Debug UI"
      return true
    elseif vim.bo[bufnr].filetype == "dapui_breakpoints" then
      self.title = "  Debug UI"
      return true
    end
  end,

  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)
    return string.rep(" ", pad) .. title .. string.rep(" ", pad)
  end,

  hl = function(self)
    if vim.api.nvim_get_current_win() == self.winid then
      return "Title"
    else
      return "Tabline"
    end
  end,
}

return M
