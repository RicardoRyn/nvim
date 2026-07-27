if vim.g.vscode then
  return
end

require("mini.misc").safely("later", function()
  local MiniMisc = require("mini.misc")
  local MiniPickExt = require("utils.mini_pick_ext")

  require("mini.pick").setup({
    mappings = {
      move_down_arrow = {
        char = "<Down>",
        func = function()
          MiniPickExt.feedkeys("<C-n>")
          vim.schedule(MiniPickExt.preview.update)
        end,
      },
      move_up_arrow = {
        char = "<Up>",
        func = function()
          MiniPickExt.feedkeys("<C-p>")
          vim.schedule(MiniPickExt.preview.update)
        end,
      },
      scroll_side_preview_down = { char = "<S-Down>", func = function() MiniPickExt.preview.scroll("down") end },
      scroll_side_preview_up = { char = "<S-Up>", func = function() MiniPickExt.preview.scroll("up") end },
      toggle_preview = "",
      toggle_side_preview = { char = "<Tab>", func = MiniPickExt.preview.toggle },
    },
    window = {
      config = function()
        local height = math.floor(0.8 * vim.o.lines)
        local width = math.floor(0.8 * vim.o.columns)
        return { height = height, width = width }
      end,
    },
  })
  require("mini.visits").setup()
  require("mini.extra").setup()

  -- UI
  vim.keymap.set("n", "<leader>uc", function() MiniExtra.pickers.colorschemes() end, { desc = "UI colorschemes" })
  vim.keymap.set("n", "<leader>uz", function() MiniMisc.zoom() end, { desc = "UI zoom" })
  -- LSP
  vim.keymap.set("n", "gD", function() MiniExtra.pickers.lsp({  scope = "declaration" }) end, { desc = "LSP declaration" })
  vim.keymap.set("n", "gd", function() MiniExtra.pickers.lsp({  scope = "definition" }) end, { desc = "LSP definition" })
  vim.keymap.set("n", "<leader>lr", function() MiniExtra.pickers.lsp({  scope = "references" }) end, { desc = "LSP references" })
  vim.keymap.set("n", "<leader>li", function() MiniExtra.pickers.lsp({  scope = "implementation" }) end, { desc = "LSP implementation" })
  vim.keymap.set("n", "<leader>lt", function() MiniExtra.pickers.lsp({  scope = "type_definition" }) end, { desc = "LSP type" })
  -- SPECIAL
  vim.keymap.set("n", "<leader><space>", function() MiniPick.builtin.files() end, { desc = "Find files" })
  vim.keymap.set("n", "<leader>//", function() MiniPick.builtin.grep_live() end, { desc = "Grep" })
  vim.keymap.set("n", "<leader>/l", function() MiniExtra.pickers.buf_lines() end, { desc = "Grep lines" })
  vim.keymap.set("n", "<leader>/w", function() MiniPick.builtin.grep() end, { desc = "Grep word" })
  vim.keymap.set("n", '<leader>s"', function() MiniExtra.pickers.registers() end, { desc = "Search registers" })
  vim.keymap.set("n", "<leader>s/", function() MiniExtra.pickers.history({ scope = "/" }) end, { desc = "Search history" })
  vim.keymap.set("n", "<leader>s:", function() MiniExtra.pickers.history({ scope = ":" }) end, { desc = "Search command history" })
  -- FIND
  vim.keymap.set("n", "<leader>fg", function() MiniExtra.pickers.git_files() end, { desc = "Find git files" })
  vim.keymap.set("n", "<leader>fr", function() MiniExtra.pickers.visit_paths() end, { desc = "Find rescent" })
  vim.keymap.set("n", "<leader>ft", function() MiniExtra.pickers.hipatterns({ scope = "current", highlighters = { "fix", "todo", "warn", "hack", "perf", "test", "tog", "note" } }) end, { desc = "Search todo comments" })
  vim.keymap.set("n", "<leader>fT", function() MiniExtra.pickers.hipatterns({ scope = "current", highlighters = { "fix", "todo", "warn", "hack" } }) end, { desc = "Search FIX/TODO etc" })
  -- SEARCH
  vim.keymap.set("n", "<leader>sb", function() MiniPick.builtin.buffers() end, { desc = "Search buffer" })
  vim.keymap.set("n", "<leader>sC", function() MiniExtra.pickers.list({ scope = "change" }) end, { desc = "Search changes" })
  vim.keymap.set("n", "<leader>sc", function() MiniExtra.pickers.commands() end, { desc = "Search commands" })
  vim.keymap.set("n", "<leader>sD", function() MiniExtra.pickers.diagnostic() end, { desc = "Search diagnostics (all)" })
  vim.keymap.set("n", "<leader>sd", function() MiniExtra.pickers.diagnostic({scope = "current"}) end, { desc = "Search diagnostics" })
  vim.keymap.set("n", "<leader>sH", function() MiniExtra.pickers.hl_groups() end, { desc = "Search highlights" })
  vim.keymap.set("n", "<leader>sh", function() MiniPick.builtin.help() end, { desc = "Search help" })
  vim.keymap.set("n", "<leader>si", function() MiniPickExt.pick_icons() end, { desc = "Search icons" })
  vim.keymap.set("n", "<leader>sJ", function() MiniExtra.pickers.list({ scope = "jump" }) end, { desc = "Search jumps" })
  vim.keymap.set("n", "<leader>sj", function() MiniExtra.pickers.git_hunks() end, { desc = "Search hunks" })
  vim.keymap.set("n", "<leader>sk", function() MiniExtra.pickers.keymaps() end, {desc = "Search keymaps"})
  vim.keymap.set("n", "<leader>sL", function() MiniExtra.pickers.list({ scope = "location" }) end, { desc = "Search location" })
  vim.keymap.set("n", "<leader>sl", function() MiniPickExt.pick_lsp_info() end, { desc = "Search LSP" })
  vim.keymap.set("n", "<leader>sm", function() MiniExtra.pickers.marks() end, { desc = "Search marks" })
  vim.keymap.set("n", "<leader>sO", function() MiniExtra.pickers.options() end, { desc = "Search options" })
  vim.keymap.set("n", "<leader>so", function() MiniExtra.pickers.oldfiles() end, { desc = "Search oldfiles" })
  vim.keymap.set("n", "<leader>sp", function() MiniExtra.pickers.spellsuggest() end, { desc = "Search spell" })
  vim.keymap.set("n", "<leader>sr", function() MiniPick.builtin.resume() end, { desc = "Search resume" })
  vim.keymap.set("n", "<leader>ss", function() MiniExtra.pickers.lsp({  scope = "document_symbol" }) end, { desc = "Search symbol" })
  vim.keymap.set("n", "<leader>sS", function() MiniExtra.pickers.lsp({  scope = "workspace_symbol" }) end, { desc = "Search symbol (workspace)" })
  vim.keymap.set("n", "<leader>st", function() MiniPickExt.grep_todo({ "FIX", "TODO", "WARN", "HACK", "PERF", "TEST", "TOG", "SETTING", "NOTE" }) end, { desc = "Search todo comments (project)" })
  vim.keymap.set("n", "<leader>sT", function() MiniPickExt.grep_todo({ "FIX", "TODO", "WARN", "HACK" }) end, { desc = "Search FIX/TODO (project)" })
  vim.keymap.set("n", "<leader>sx", function() MiniExtra.pickers.list({ scope = "quickfix" }) end, { desc = "Search quickfixes" })
end)
