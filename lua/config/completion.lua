local M = {}
local snippets_ready, completion_ready = false, false

function M.ensure_snippets()
  if snippets_ready then return end
  local snippets = require("mini.snippets")
  snippets.setup({ snippets = { snippets.gen_loader.from_lang() } })
  snippets.start_lsp_server()
  snippets_ready = true
end

function M.ensure_completion()
  if completion_ready then return end
  M.ensure_snippets()
  require("mini.completion").setup()
  completion_ready = true
end

return M
