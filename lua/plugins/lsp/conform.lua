local function notify_formatters(formatters)
  return function()
    vim.notify("Formatter: **" .. table.concat(formatters, ", ") .. "**", vim.log.levels.INFO)
    return formatters
  end
end

return {
  "stevearc/conform.nvim",
  cond = not vim.g.vscode,
  cmd = { "ConformInfo" },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    stop_after_first = false,
    formatters_by_ft = {
      -- NOTE: LUA
      lua = notify_formatters({ "stylua" }),
      -- NOTE: PYTHON
      python = notify_formatters({ "ruff_format" }),
      -- NOTE: BASH
      bash = notify_formatters({ "shfmt" }),
      sh = notify_formatters({ "shfmt" }),
      -- NOTE: MARKDOWN
      markdown = notify_formatters({ "injected", "prettierd" }),
      quarto = notify_formatters({ "injected" }),
      -- NOTE: YAML
      yaml = notify_formatters({ "prettierd" }),
      -- NOTE: RUST
      rust = notify_formatters({ "rustfmt" }),
    },
  },

  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true }, function(err)
          if not err then
            local mode = vim.api.nvim_get_mode().mode
            -- 如果在 Visual 模式下，退出 Visual
            if vim.startswith(string.lower(mode), "v") then
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
          end
        end)
      end,
      desc = "Code Format",
      mode = { "n", "v" }, -- 普通模式和可视模式都生效
    },
  },

  config = function(_, opts)
    require("conform").setup(opts)
    -- 支持markdown中的代码块的格式化
    -- Customize the "injected" formatter
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
}
