if vim.g.vscode then return end

require("markview").setup({
  markdown_inline = {
    inline_codes = {
      enable = true,
      hl = "MarkviewCode",
      padding_left = " ",
      padding_right = " ",
    },
  },
  markdown = {
    headings = {
      enable = true,

      heading_1 = {
        style = "icon",
        sign = "󰌕 ",
        sign_hl = "MarkviewHeading1Sign",

        icon = "󰼏 %d ",
        hl = "MarkviewHeading1",
      },
      heading_2 = {
        style = "icon",
        sign = "󰌖 ",
        sign_hl = "MarkviewHeading2Sign",

        icon = "󰎨 %d.%d ",
        hl = "MarkviewHeading2",
      },
      heading_3 = {
        style = "icon",

        icon = "󰼑 %d.%d.%d ",
        hl = "MarkviewHeading3",
      },
      heading_4 = {
        style = "icon",

        icon = "󰎲 %d.%d.%d.%d ",
        hl = "MarkviewHeading4",
      },
      heading_5 = {
        style = "icon",

        icon = "󰼓 %d.%d.%d.%d.%d ",
        hl = "MarkviewHeading5",
      },
      heading_6 = {
        style = "icon",

        icon = "󰎴 %d.%d.%d.%d.%d.%d ",
        hl = "MarkviewHeading6",
      },
      shift_width = 0,
    },
    code_blocks = {
      sign = false,
      pad_amount = 0,
    },
    list_items = {
      shift_width = 0,
    },
  },
})
