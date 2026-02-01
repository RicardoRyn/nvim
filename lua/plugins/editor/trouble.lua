return {
  "folke/trouble.nvim",
  cond = not vim.g.vscode,
  cmd = "Trouble",
  keys = {
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
  },
  opts = {
    modes = {
      lsp_references = {
        params = {
          include_declaration = true,
        },
      },
      lsp_base = {
        params = {
          include_current = false,
        },
      },
      symbols = {
        desc = "document symbols",
        mode = "lsp_document_symbols",
        focus = false,
        win = { position = "right", size = 0.25 },
        filter = {
          -- remove Package since luals uses it for control flow structures
          ["not"] = { ft = "lua", kind = "Package" },
          any = {
            -- all symbol kinds for help / markdown files
            ft = { "help", "markdown" },
            kind = {
              "Array", -- LSP 符号类型：数组类型
              "Boolean", -- LSP 符号类型：布尔类型
              "Class", -- LSP 符号类型：类定义
              "Constant", -- LSP 符号类型：常量定义
              "Constructor", -- LSP 符号类型：构造函数
              "Enum", -- LSP 符号类型：枚举类型
              "EnumMember", -- LSP 符号类型：枚举成员
              "Event", -- LSP 符号类型：事件
              "Field", -- LSP 符号类型：字段/成员变量
              "File", -- LSP 符号类型：文件
              "Function", -- LSP 符号类型：函数定义
              "Interface", -- LSP 符号类型：接口定义
              "Key", -- LSP 符号类型：键（如对象键）
              "Method", -- LSP 符号类型：方法定义
              "Module", -- LSP 符号类型：模块
              "Namespace", -- LSP 符号类型：命名空间
              "Null", -- LSP 符号类型：空值类型
              "Number", -- LSP 符号类型：数字类型
              -- "Object", -- LSP 符号类型：对象类型
              "Operator", -- LSP 符号类型：操作符
              "Package", -- LSP 符号类型：包
              "Property", -- LSP 符号类型：属性
              "String", -- LSP 符号类型：字符串类型
              "Struct", -- LSP 符号类型：结构体定义
              "TypeParameter", -- LSP 符号类型：类型参数（泛型）
              "Variable", -- LSP 符号类型：变量定义
            },
          },
        },
      },
    },
    icons = {
      indent = {
        last = "╰╴",
      },
      kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        String = " ",
        Struct = "󰆼 ",
        TypeParameter = " ",
        Variable = "󰀫 ",
      },
    },
  },
}
