-- 识别 #FF0000, #00FF00, #0000FF
-- 识别 rgb(255,0,0),  rgba(255,255,0,255)
-- 识别 hsl(0, 100%, 50%),  hsla(240, 100%, 50%, 0.5)
-- 识别 #991 #a1f #11f

return {
  "brenoprata10/nvim-highlight-colors",
  cond = not vim.g.vscode,
  opts = {
    ---Render style
    ---@usage 'background'|'foreground'|'virtual'
    render = "virtual",
  },
}
