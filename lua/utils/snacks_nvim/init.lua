local snacks_indent = require("utils.snacks_nvim.indent")
local snacks_explorer_preview = require("utils.snacks_nvim.explorer_preview")
local sys = require("utils.system")

require("snacks").setup({
  bigfile = { enabled = true },
  debug = { enabled = true },
  explorer = { enabled = false },
  gh = { enabled = true },
  gitbrowse = {
    open = function(url)
      if vim.fn.has("nvim-0.10") == 0 or sys.is_win then
        require("lazy.util").open(url, { system = true })
        return
      end
      vim.ui.open(url)
    end,
  },
  image = { enabled = not sys.is_win },
  indent = snacks_indent,
  input = { enabled = false },  -- for uniform ui
  notifier = {
    enabled = true,
    timeout = 3000,
    margin = { top = 0, right = 1, bottom = 1 },
    top_down = false,
    style = "fancy",
    date_format = "%H:%M:%S",
  },
  picker = snacks_explorer_preview,
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  styles = { notification = { wo = { wrap = true }, border = "rounded" } },
  words = { enabled = true },
})
require("utils.snacks_nvim.debug")

-- file
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Find recent files" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find config file" })
vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Find projects" })
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find git files" })
vim.keymap.set("n", "<leader>ft", function() Snacks.picker.todo_comments({ buffers = true }) end, { desc = "Find todos in buffers" })
vim.keymap.set("n", "<leader>fT", function() Snacks.picker.todo_comments({ keywords = { "FIX", "TODO" }, buffers = true }) end, { desc = "Find Todo/Fix in buffers" })
-- grep
vim.keymap.set("n", "<leader>/l", function() Snacks.picker.lines() end, { desc = "Grep lines" })
vim.keymap.set("n", "<leader>/b", function() Snacks.picker.grep_buffers() end, { desc = "Grep buffers" })
vim.keymap.set({ "n", "x" }, "<leader>/w", function() Snacks.picker.grep_word() end, { desc = "Grep word" })
vim.keymap.set("n", "<leader>//", function() Snacks.picker.grep() end, { desc = "Grep" })
-- search
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart find files" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.commands() end, { desc = "Search commands" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics() end, { desc = "Search diagnostics" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Search diagnostics (buffer)" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search help pages" })
vim.keymap.set("n", "<leader>sI", function() Snacks.picker.lsp_incoming_calls() end, { desc = "Search incoming calls" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Search icons" })
vim.keymap.set("n", "<leader>sJ", function() Snacks.picker.jumps() end, { desc = "Search jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Search keymaps" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.lsp_config() end, { desc = "Search LSP info" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Search marks" })
vim.keymap.set("n", "<leader>sO", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "Search outgoing calls" })
vim.keymap.set("n", "<leader>sP", function() Snacks.picker() end, { desc = "Search pickers" })
vim.keymap.set("n", "<leader>sp", function() Snacks.picker.spelling() end, { desc = "Search spelling" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Search resume" })
vim.keymap.set("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "FIX", "TODO", "HACK", "WARN" } }) end, { desc = "Search todo/fix" })
vim.keymap.set("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Search todos" })
-- vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Search undotree" })
vim.keymap.set("n", "<leader>sv", function() Snacks.picker.cliphist() end, { desc = "Search clipboard history" })
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Search registers" })
vim.keymap.set("n", '<leader>s.', function() Snacks.scratch.select() end, { desc = "Search scratch" })
vim.keymap.set("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search history" })
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Scratch" })
vim.keymap.set({ "n", "v" }, "<leader>s:", function() Snacks.picker.command_history() end, { desc = "Search command history" })
vim.keymap.set("n", "<leader>z", function() Snacks.picker.zoxide() end, { desc = "Zoxide" })
-- LSP
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Search LSP symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Search LSP Symbols in workspace" })
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Snacks goto definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Snacks goto declaration" })
vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "Snacks goto references" })
-- vim.keymap.set("n", "gri", function() Snacks.picker.lsp_implementations() end, { desc = "Snacks goto implementation" })
-- vim.keymap.set("n", "grt", function() Snacks.picker.lsp_type_definitions() end, { desc = "Snacks goto type definition" })
-- git
vim.keymap.set("n", "<leader>ghi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>ghI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>ghp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>ghP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })
-- terminal
vim.keymap.set({ "n", "t" }, "<C-/>", function() Snacks.terminal(nil, { win = { height = 0.3, position = "bottom" } }) end, { desc = "Open Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", function() Snacks.terminal(nil, { win = { height = 0.3, position = "bottom" } }) end, { desc = "Open Terminal" })
vim.keymap.set("n", "<leader>tt", function() Snacks.terminal(nil, { win = { height = 0.3, position = "bottom" } }) end, { desc = "Terminal bottom" })
vim.keymap.set("n", "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right" } }) end, { desc = "Terminal split" })
vim.keymap.set("n", "<leader>tf", function() Snacks.terminal(nil, { win = { position = "float" } }) end, { desc = "Terminal float" })
-- ui
vim.keymap.set("n", "<leader>n", function() Snacks.notifier.show_history() end, { desc = "Notification" })
vim.keymap.set("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss notifications" })
vim.keymap.set("n", "<leader>es", function() Snacks.explorer() end, { desc = "Snacks explorer" })
vim.keymap.set("n", "<leader>uc", function() Snacks.picker.colorschemes() end, { desc = "Select colorschemes" })
-- dev
vim.keymap.set({ "n", "v" }, "<leader>Dr", function() Snacks.debug.run() end, { desc = "Snacks run lua" })
vim.keymap.set({ "n", "v" }, "<leader>Dm", function() Snacks.debug.metrics() end, { desc = "Snacks metrics" })
vim.keymap.set("n", "<leader>Ds", function()
  local input = vim.fn.input("Enter value to measure: ")
  if input == "" then
    vim.notify("Cancelled or empty input", vim.log.levels.WARN)
    return
  end
  local num = tonumber(input)
  if num == nil then
    vim.notify("Invalid number: " .. input, vim.log.levels.ERROR)
    return
  end
  local measured = Snacks.debug.size(num)
  vim.notify(measured)
end, { desc = "Snacks size" })

-- Create some toggle mappings
Snacks.toggle.option("background", { off = "light", on = "dark", name = "background" }):map("<leader>ub")
Snacks.toggle.diagnostics( {name = "diagnostics"} ):map("<leader>ud")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.inlay_hints({ name = "inlay hints" }):map("<leader>uh")
Snacks.toggle.option("relativenumber", { name = "relative number" }):map("<leader>ul")
Snacks.toggle.line_number({ name = "number" }):map("<leader>uL")
Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")
Snacks.toggle.zoom():map("<leader>uz")
Snacks.toggle.zen():map("<leader>uZ")
