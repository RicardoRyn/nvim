return {
  "NvChad/nvim-colorizer.lua",
  cond = not vim.g.vscode,
  event = "BufReadPre",
  config = function()
    require("colorizer").setup({
      filetypes = { "*" }, -- 所有文件类型都启用
      user_default_options = {
        names = true, -- 识别 red blue
        rgb_fn = true, -- 识别 rgb(111,111,111) rgba(111,111,111,255)
        hsl_fn = true, -- 识别 hsl(0, 100%, 50%) hsla(240, 100%, 50%, 0.5)
        tailwind = true, -- 识别 <div class="bg-red-500 text-blue-200 border-green-300"></div>
        css = true, -- 识别 #991 #a1f #111111
        mode = "background", -- 或 "foreground"
      },
    })
  end,
}
