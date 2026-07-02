if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("conform").setup({
      notify_on_error = false,
      format_on_save = false,
      stop_after_first = false,
      formatters_by_ft = {
        -- lua
        lua = { "stylua" },
        -- python
        python = { "ruff_organize_imports", "ruff_format" },
        -- bash
        bash = { "shfmt" },
        sh = { "shfmt" },
        -- rust
        rust = { "rustfmt" },
        -- markdown
        markdown = { "injected", "prettierd" },
        quarto = { "injected" },
        -- json
        json = { "prettierd" },
        jsonc = { "prettierd" },
        -- yaml
        yaml = { "prettierd" },
        yml = { "prettierd" },
      },
      formatters = {
        miss_hit = { command = "mh_style", args = { "--fix", "$FILENAME" }, stdin = false, exit_codes = { 0, 1 } },
        latexindent = { prepend_args = { "-y=defaultIndent:'  '" } },
      },
    })
    require("conform").formatters.injected = {
      -- Set the options field
      options = {
        -- Set to true to ignore errors
        ignore_errors = false,
        -- Map of treesitter language to file extension
        -- A temporary file name with this extension will be generated during formatting
        -- because some formatters care about the filename.
        lang_to_ext = {
          bash = "sh",
          c_sharp = "cs",
          elixir = "exs",
          javascript = "js",
          julia = "jl",
          latex = "tex",
          markdown = "md",
          python = "py",
          ruby = "rb",
          rust = "rs",
          teal = "tl",
          r = "r",
          typescript = "ts",
        },
        -- Map of treesitter language to formatters to use
        -- (defaults to the value from formatters_by_ft)
        lang_to_formatters = {},
      },
    }
  end,
  keys = {
    {
      { "n", "v" },
      "<leader>lf",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
            vim.notify("✨ Code formatted successfully!", vim.log.levels.INFO, { title = "Conform" })
          else
            vim.notify("❗ Formatting failed!", vim.log.levels.ERROR, { title = "Conform" })
          end
        end)
      end,
      { desc = "LSP format" },
    },
  },
})
