return {
  "yetone/avante.nvim",
  enabled = false,
  cond = not vim.g.vscode,
  event = "VeryLazy",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
  version = false, -- 永远不要将此值设置为 "*"！永远不要！
  opts = {
    provider = "deepseek",
    providers = {
      deepseek = {
        __inherited_from = "openai",
        api_key_name = "AVANTE_DEEPSEEK_API_KEY",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-coder",
        max_tokens = 8192,
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
