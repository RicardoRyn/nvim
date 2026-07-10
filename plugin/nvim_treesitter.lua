if vim.g.vscode then
  return
end

local ensure_installed = {
  "lua",
  "python",
  "bash",
  "rust",
  "markdown",
  "markdown_inline",
  "diff",
  "json",
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

require("nvim-treesitter").install(ensure_installed)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local buf = args.buf
    local ft = vim.bo[buf].filetype

    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    local ok_add, _ = pcall(vim.treesitter.language.add, lang)
    if not ok_add then
      return
    end

    pcall(vim.treesitter.start, buf, lang)
  end,
})
