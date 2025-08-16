if vim.g.vscode then
  return {}
else
  return {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",

        "pyright",
        "ruff",
        "isort",
        "black",

        "bash-language-server",
        "shellcheck",
        "shfmt",

        "marksman", -- LSP (语法高亮、补全、跳转)
        "markdownlint-cli2", -- 静态检查
        "prettierd", -- 格式化
      }
    },
    config = function(_, opts)

      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end
  }
end
