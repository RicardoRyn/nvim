if vim.g.vscode then
  return {}
else
  return {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
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
    opts = {
      notify_on_error = false,
      format_on_save = false,
      stop_after_first = true, -- 只运行第一个 formatter
      formatters_by_ft = {
        lua = { "stylua" }, -- 支持 range_args，Visual 模式选中行可以格式化

        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          else
            return { "isort", "black" } -- Black 只能整个 buffer
          end
        end,

        bash = { "shfmt" }, -- 支持 range_args
        sh = { "shfmt" },

        markdown = { "injected", "prettierd" }, -- 支持 range_args
        quarto = { "injected" },
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
end
