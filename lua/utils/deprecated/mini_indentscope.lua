if vim.g.vscode then
  return
end

require("mini.misc").safely("later", function()
  require("mini.indentscope").setup({
    -- disable, handled by rainbow_indent module
    draw = {
      delay = 0,
      animation = function()
        return 0
      end,
      predicate = function()
        return false
      end,
    },
  })

  local augroup = vim.api.nvim_create_augroup("SetupMiniIndentscope", { clear = true })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      local bt = vim.bo.buftype
      if bt == "help" or bt == "terminal" or bt == "nofile" or bt == "prompt" then
        vim.b.miniindentscope_disable = true
      else
        vim.b.miniindentscope_disable = false
      end
    end,
  })

  require("utils.rainbow_indent").setup()
end)
