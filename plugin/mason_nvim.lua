if vim.g.vscode then return end

local my_languages = {
  -- lua
  "lua-language-server",
  "stylua",
  -- python
  "pyright",
  "debugpy",
  "ruff",
  -- bash
  "bash-language-server",
  "shellcheck",
  "shfmt",
  "bash-debug-adapter",
  -- MARKDOWN
  "marksman",
  "prettierd",
  -- RUST
  "rust-analyzer",
  "codelldb",
}

require("mason").setup({ ensure_installed = my_languages })

local mr = require("mason-registry")

local function ensure_installed()
  for _, tool in ipairs(my_languages) do
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
