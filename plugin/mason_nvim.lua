if vim.g.vscode then
  return
end

require("mini.misc").safely("now", function()
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
    -- LATEX
    "texlab",
    "latexindent",
  }

  require("mason").setup()

  local mr = require("mason-registry")
  local missing = {}
  for _, name in ipairs(my_languages) do
    if not mr.is_installed(name) then
      missing[#missing + 1] = name
    end
  end

  if #missing == 0 then
    return
  end

  mr.refresh(function(ok)
    if not ok then
      vim.notify("Mason registry 刷新失败，请用 :MasonLog 检查", vim.log.levels.WARN)
      return
    end

    for _, name in ipairs(missing) do
      local found, pkg = pcall(mr.get_package, name)
      if not found then
        vim.notify("Mason 找不到包：" .. name, vim.log.levels.WARN)
      elseif not pkg:is_installed() and not pkg:is_installing() then
        pkg:install()
      end
    end
  end)
end)
