if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("jj").setup({
      picker = { snacks = {} },
      cmd = {
        keymaps = {
          log = {
            edit_immutable = "E",
          },
        },
      },
    })
  end,
  -- stylua: ignore
  keys = {
    -- { "n", "<leader>ja", function() require("jj.annotate").file() end, { desc = "JJ annotate file" } },
    { "n", "<leader>jA", function() require("jj.cmd").abandon() end, {desc = "JJ abandon"} },
    { "n", "<leader>jbc", function() require("jj.cmd").bookmark_create() end, { desc = "JJ bookmark create" } },
    { "n", "<leader>jbd", function() require("jj.cmd").bookmark_delete() end, { desc = "JJ bookmark delete" } },
    { "n", "<leader>jbm", function() require("jj.cmd").bookmark_move() end, { desc = "JJ bookmark move" } },
    { "n", "<leader>jB", "<cmd>Jbrowse<cr>", { desc = "JJ browse" } },
    { "v", "<leader>jB", ":Jbrowse<cr>", { desc = "JJ browse" } },
    { "n", "<leader>jd", function() require("jj.diff").open_vdiff() end, { desc = "JJ diff current buffer" } },
    { "n", "<leader>jD", function() require("jj.cmd").describe() end, { desc = "JJ describe" } },
    { "n", "<leader>je", function() require("jj.cmd").edit() end, { desc = "JJ edit" } },
    { "n", "<leader>jf", function() require("jj.cmd").fetch() end, { desc = "JJ fetch" } },
    { "n", "<leader>jl", function() require("jj.cmd").log({ revisions = "::", limit = 1000 }) end, { desc = "JJ log all", } },
    { "n", "<leader>jL", function() require("jj.cmd").log() end, { desc = "JJ log" } },
    { "n", "<leader>jn", function() require("jj.cmd").new() end, { desc = "JJ new" } },
    { "n", "<leader>jpl", function() require("jj.cmd").open_pr({ list_bookmarks = true }) end, { desc = "JJ open PR listing available bookmarks", } },
    { "n", "<leader>jpp", function() require("jj.cmd").push() end, { desc = "JJ push" } },
    { "n", "<leader>jpr", function() require("jj.cmd").open_pr() end, { desc = "JJ open PR from bookmark in current revision or parent", } },
    { "n", "<leader>jr", function() require("jj.cmd").rebase() end, { desc = "JJ rebase" } },
    { "n", "<leader>jR", function() require("jj.cmd").redo() end, { desc = "JJ redo" } },
    { "n", "<leader>js", function() require("jj.cmd").status() end, { desc = "JJ status" } },
    { "n", "<leader>jS", function() require("jj.cmd").squash() end, { desc = "JJ squash" } },
    { "n", "<leader>jts", function() require("jj.cmd").tag_set() end, { desc = "JJ tag set", } },
    { "n", "<leader>jtd", function() require("jj.cmd").tag_delete() end, { desc = "JJ tag delete", } },
    { "n", "<leader>jtp", function() require("jj.cmd").tag_push() end, { desc = "JJ tag push", } },
    { "n", "<leader>jU", function() require("jj.cmd").undo() end, { desc = "JJ undo" } },
    { "n", "<leader>sj", function() require("jj.picker").status() end, { desc = "Search diff files" } },
  },
  cmd = { "J", "Jdiff", "Jedit", "Jread", "Jhdiff", "Jsplit", "Jvdiff", "Jbrowse", "Jvslplit", "Jtabedit" },
})
