return {
  "nicolasgb/jj.nvim",
  cond = not vim.g.vscode,
  version = "*", -- Use latest stable release
  dependencies = {
    "folke/snacks.nvim",
    "esmuellert/codediff.nvim",
  },
  cmd = {
    "J",
    "Jdiff",
    "Jhdiff",
    "Jvdiff",
  },
  -- stylua: ignore
  keys = {
    { "<leader>ja", function() require("jj.annotate").file() end, desc = "JJ annotate file" },
    { "<leader>jA", function() require("jj.cmd").abandon() end, desc = "JJ abandon" },
    { "<leader>jbc", function() require("jj.cmd").bookmark_create() end, desc = "JJ bookmark create" },
    { "<leader>jbd", function() require("jj.cmd").bookmark_delete() end, desc = "JJ bookmark delete" },
    { "<leader>jbm", function() require("jj.cmd").bookmark_move() end, desc = "JJ bookmark move" },
    { "<leader>jd", function() require("jj.diff").open_vdiff({ rev = "@-" }) end, desc = "JJ diff current buffer" },
    { "<leader>jD", function() require("jj.cmd").describe() end, desc = "JJ describe" },
    { "<leader>je", function() require("jj.cmd").edit() end, desc = "JJ edit" },
    { "<leader>jf", function() require("jj.cmd").fetch() end, desc = "JJ fetch" },
    { "<leader>jl", function() require("jj.cmd").log({ revisions = "::", limit = 1000 }) end, desc = "JJ log all", },
    { "<leader>jL", function() require("jj.cmd").log() end, desc = "JJ log" },
    { "<leader>jn", function() require("jj.cmd").new() end, desc = "JJ new" },
    { "<leader>jp", function() require("jj.cmd").push() end, desc = "JJ push" },
    { "<leader>jpr", function() require("jj.cmd").open_pr() end, desc = "JJ open PR from bookmark in current revision or parent", },
    { "<leader>jpl", function() require("jj.cmd").open_pr({ list_bookmarks = true }) end, desc = "JJ open PR listing available bookmarks", },
    { "<leader>jr", function() require("jj.cmd").rebase() end, desc = "JJ rebase" },
    { "<leader>jR", function() require("jj.cmd").redo() end, desc = "JJ redo" },
    { "<leader>js", function() require("jj.cmd").status() end, desc = "JJ status" },
    { "<leader>jS", function() require("jj.cmd").squash() end, desc = "JJ squash" },
    { "<leader>jt", function() local cmd = require("jj.cmd") cmd.j("tug") cmd.log({}) end, desc = "JJ tug", },
    { "<leader>jU", function() require("jj.cmd").undo() end, desc = "JJ undo" },
    { "<leader>sj", function() require("jj.picker").status() end, desc = "JJ Picker status" },
  },
  opts = {
    picker = { snacks = {} },
    terminal = { cursor_render_delay = 10 },
    diff = { backend = "codediff" },
    cmd = {
      describe = {
        editor = {
          type = "buffer",
          keymaps = {
            close = { "q", "<Esc>", "<C-c>" },
          },
        },
      },
      bookmark = { prefix = "" },
      keymaps = {
        log = {
          checkout = "<CR>",
          describe = "d",
          diff = "<S-d>",
          abandon = "<S-a>",
          fetch = "<S-f>",
        },
        status = {
          open_file = "<CR>",
          restore_file = "<S-x>",
        },
        close = { "q", "<Esc>" },
      },
    },
  },
}
