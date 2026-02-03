return {
  "nvim-mini/mini.files",
  cond = not vim.g.vscode,
  version = false,
  keys = {
    { "<leader>ee", "<CMD>lua MiniFiles.open()<CR>", desc = "Mini Files" },
    { "<leader>ef", "<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>", desc = "Mini Files" },
  },
  opts = {
    content = {
      filter = require("utils.mini_files_ext").filter_hide,
    },
    mappings = {
      go_in = "K",
      go_in_plus = "L",
      go_out = "J",
      go_out_plus = "H",
      synchronize = "<CR>",
    },
    windows = {
      width_preview = SYSTEM.distro == "arch" and 80 or 120,
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    local MiniFilesExts = require("utils.mini_files_ext")

    -- Setup keymaps on buffer creation
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        MiniFilesExts.setup_keymaps(args.data.buf_id)
      end,
    })

    -- Setup git status
    MiniFilesExts.setup_git_status()
  end,
}
