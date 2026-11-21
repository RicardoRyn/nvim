if vim.g.vscode then
  return
end

require("utils.lazy").register({
  setup = function()
    -- -- 使用diffbandit作为后端
    -- local diff = require("jj.diff")
    -- local bandit = require("diffbandit")
    --
    -- local function report(view, err)
    --   if not view and err then
    --     vim.notify("DiffBandit: " .. err, vim.log.levels.WARN)
    --   end
    --   return view
    -- end
    --
    -- -- jj log/status can call us from a non-file buffer. Use its cwd, not its buffer name.
    -- local function review(open)
    --   return function(opts)
    --     local path = opts.path and vim.fn.fnamemodify(opts.path, ":p")
    --     local root = vim.fs.root(path or vim.fn.getcwd(), ".jj")
    --     if not root then
    --       return report(nil, "Not in a jj workspace")
    --     end
    --     local pathspecs = path and { vim.fs.relpath(root, path) } or nil
    --     return report(open(opts, { root = root, pathspecs = pathspecs }))
    --   end
    -- end
    --
    -- diff.register_backend("diffbandit", {
    --   diff_current = function(opts)
    --     local path = opts.path or vim.api.nvim_buf_get_name(0)
    --     if vim.startswith(path, "jj://") then
    --       -- A revision buffer (possibly modified) is not a working-copy file.
    --       return diff.diff_current(vim.tbl_extend("force", opts, { backend = "native" }))
    --     end
    --     if path == "" then
    --       return report(nil, "Current buffer has no file path")
    --     end
    --     return report(bandit.git_file(path, { mode = "all", base = opts.rev or "@-" }))
    --   end,
    --   -- show_revision = review(function(opts, args)
    --   --   return bandit.git_commit(opts.rev, args)
    --   -- end),
    --   diff_revisions = review(function(opts, args)
    --     args.direct = true -- compare the two trees, not their merge base
    --     return bandit.git_compare(opts.left, opts.right, args)
    --   end),
    --   diff_history_revisions = review(function(opts, args)
    --     -- Visual selections in jj log usually give the newest revision first.
    --     args.rev = ("coalesce((%s)..(%s), (%s)..(%s))"):format(opts.left, opts.right, opts.right, opts.left)
    --     return bandit.git_log(args)
    --   end),
    -- })

    require("jj").setup({
      diff = {
        backend = "native",
      },
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
    { "n", "<leader>ja", function() require("jj.annotate").file() end, { desc = "JJ annotate file" } },
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
    { "n", "<leader>jN", function() require("jj.cmd").new({ args = { "--insert-before", "@" } }) end, { desc = "JJ new insert before" } },
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
    { "n", "<leader>sj", function() require("jj.picker").status() end, { desc = "Search jj changed files" } },
  },
  cmd = { "J", "Jdiff", "Jedit", "Jread", "Jhdiff", "Jsplit", "Jvdiff", "Jbrowse", "Jvslplit", "Jtabedit" },
})
