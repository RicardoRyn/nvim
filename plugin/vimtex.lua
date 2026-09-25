if vim.g.vscode then
  return
end

vim.g.vimtex_view_method = "general"
vim.g.vimtex_view_general_viewer = "SumatraPDF.exe"
vim.g.vimtex_view_general_options = "-forward-search @tex @line @pdf"
vim.g.vimtex_syntax_enabled = 0

-- vimtex 创建映射时不带 desc，mini.clue 无法显示说明。
-- 这里在其映射建立后，从 <Plug>(vimtex-xxx) 名称自动生成 desc 并重新注册。
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(args)
    for _, mode in ipairs({ "n", "x", "o" }) do
      -- Neovim >= 0.11 中该 API 为同步调用，仅接受 2 个参数
      for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, mode)) do
        local name = map.rhs and map.rhs:match("<[Pp]lug>%((vimtex%-[^%)]+)%)")
        if name and (map.desc == nil or map.desc == "") then
          vim.keymap.set(mode, map.lhs, map.rhs, {
            buffer = args.buf,
            remap = true,
            desc = name:sub(#("vimtex-") + 1):gsub("-", " "),
            nowait = map.nowait == true or map.nowait == 1,
            silent = map.silent == true or map.silent == 1,
            expr = map.expr == true or map.expr == 1,
          })
        end
      end
    end
  end,
})
