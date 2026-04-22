return {
  "romus204/tree-sitter-manager.nvim",
  enabled = false,
  cond = not vim.g.vscode,
  dependencies = {},
  config = function()
    local languages = {
      "lua",
      "python",
      "bash",
      "rust",
      "json",
      "markdown",
      "markdown_inline",
      "css",
      "html",
      "javascript",
      "latex",
      "scss",
      "svelte",
      "tsx",
      "typst",
      "vue",
      "regex",
    }

    require("tree-sitter-manager").setup({
      -- Default Options
      ensure_installed = languages,
      -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
      auto_install = true, -- if enabled, install missing parsers when editing a new file
      highlight = true, -- treesitter highlighting is enabled by default
      languages = {
        -- python = {
        --   install_info = {
        --     use_repo_queries = true,
        --   },
        -- },
      }, -- override or add new parser sources
      -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
      -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
    })

    -- vim.api.nvim_create_autocmd("FileType", {
    --   pattern = languages,
    --   callback = function()
    --     vim.treesitter.start()
    --   end,
    -- })

  end,
}
