require("utils.lazy").load({
  setup = function()
    local MiniFilesExts = require("utils.mini_files_ext")
    require("mini.files").setup({
      content = {
        filter = MiniFilesExts.filter_hide,
      },
      mappings = {
        go_in = "K",
        go_in_plus = "L",
        go_out = "J",
        go_out_plus = "H",
        synchronize = "<CR>",
      },
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        MiniFilesExts.setup_keymaps(args.data.buf_id)
      end,
    })
  end,
  -- stylua: ignore
  keys = {
    { "n", "<leader>ee", function() MiniFiles.open() end, { desc = "Files" }, },
    { "n", "<leader>ef", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, { desc = "Files in current folder" }, },
  },
})
