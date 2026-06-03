return {
  "stevearc/conform.nvim",
  cond = not vim.g.vscode,
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            -- 如果在 Visual 模式下，退出 Visual
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
            vim.notify("✨ Code formatted successfully!", vim.log.levels.INFO, { title = "Conform" })
          else
            vim.notify("⚠️ Formatting failed!", vim.log.levels.ERROR, { title = "Conform" })
          end
        end)
      end,
      desc = "Code Format",
      mode = { "n", "v" },
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    stop_after_first = false,
    formatters_by_ft = {
      -- LUA
      lua = { "stylua" },
      -- PYTHON
      python = { "ruff_organize_imports", "ruff_format" },
      -- BASH
      bash = { "shfmt" },
      sh = { "shfmt" },
      -- RUST
      rust = { "rustfmt" },
      -- MARKDOWN
      markdown = { "injected", "prettierd" },
      quarto = { "injected" },
      -- JSON
      json = { "prettierd" },
      jsonc = { "prettierd" },
      -- YAML
      yaml = { "prettierd" },
      yml = { "prettierd" },
      -- MATLAB
      matlab = { "miss_hit" },
      -- LATEX
      tex = { "latexindent" },
      plaintex = { "latexindent" },
    },
    formatters = {
      miss_hit = { command = "mh_style", args = { "--fix", "$FILENAME" }, stdin = false, exit_codes = { 0, 1 } },
      latexindent = { prepend_args = { "-y=defaultIndent:'  '" } },
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
    -- 支持markdown中的代码块的格式化
    require("conform").formatters.injected = {
      options = {
        ignore_errors = true,
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
        lang_to_formatters = {},
      },
    }
  end,
}
