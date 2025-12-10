return {
  "yetone/avante.nvim",
  cond = not vim.g.vscode,
  -- 如果你想从源码构建，请执行 `make BUILD_FROM_SOURCE=true`
  -- ⚠️ 必须添加这个设置！! !
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false, -- 永远不要将此值设置为 "*"！永远不要！
  opts = {
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
    -- 在此处添加任何选项
    mode = "legacy", -- "agentic" | "legacy"
    behaviour = {
      auto_add_current_file = true,
      auto_set_keymaps = true,
    },
    selection = {
      enabled = false,
    },
    windows = {
      width = 40,
      ask = {
        floating = false, -- Open the 'AvanteAsk' prompt in a floating window
        start_insert = false,
      },
      input = {
        prefix = "",
        height = 10,
      },
    },
    shortcuts = {
      {
        name = "trans",
        description = "翻译文本或代码",
        details = "将选中的文本或代码翻译成中文/English，同时保留含义、语气和技术准确性",
        prompt = "尽可能简短回答，请将选中的文本或代码准确、清晰地翻译成中文/英文，并确保保留原意。",
      },
    },
    -- 此文件可以包含针对你项目的特定指令
    instructions_file = "avante.md",
    -- 例如
    provider = "qwen_plus",
    providers = {
      deepseek = {
        endpoint = "https://api.deepseek.com",
        model = "deepseek-chat",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
        __inherited_from = "openai",
        api_key_name = "AVANTE_DEEPSEEK_API_KEY",
      },
      qwen_plus = {
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        model = "qwen-plus",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
        __inherited_from = "openai",
        api_key_name = "AVANTE_QIANWEN_API_KEY",
      },
      qwen3_max = {
        endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
        model = "qwen3-max",
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
        __inherited_from = "openai",
        api_key_name = "AVANTE_QIANWEN_API_KEY",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
