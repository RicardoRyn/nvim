if vim.g.vscode then return end

require("utils.lazy").load({
  setup = function()
    require("sidekick").setup({
      nes = {
        diff = {
          inline = "chars",
        },
      },
      cli = {
        win = {
          layout = "right",
          split = {
            width = 0.34, -- set to 0 for default split width
          },
          keys = {
            hide_ctrl_q = false,
            hide_ctrl_z = false,
          },
        },
        mux = {
          backend = "zellij",
          enabled = false,
        },
        tools = {
          pi = { cmd = { "pi", "-c", "--plan" } },
        },
        prompts = {
          changes = "你能审查一下我的更改吗？",
          diagnostics = "你能帮我解释 {file} 中的诊断问题吗？\n{diagnostics}",
          diagnostics_all = "你能帮我解释这些诊断问题吗？\n{diagnostics_all}",
          document = "为 {function|line} 添加文档",
          explain = "解释 {this}",
          fix = "你能修复 {this} 吗？",
          optimize = "如何优化 {this}？",
          review = "你能审查 {file} 中是否存在任何问题或改进空间吗？",
          tests = "你能为 {this} 编写测试吗？",
          translate = "{selection}\n将上述内容翻译成中文。",
          buffers = "{buffers}",
          file = "{file}",
          line = "{line}",
          position = "{position}",
          quickfix = "{quickfix}",
          selection = "{selection}",
          ["function"] = "{function}",
          class = "{class}",
        },
      },
    })
  end,
  keys = {
    {
      "n",
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      { expr = true, desc = "Goto/Apply Next Edit Suggestion" },
    },
    {
      { "n", "t", "i", "x" },
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      { desc = "Sidekick toggle" },
    },
    {
      "n",
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      { desc = "Sidekick toggle" },
    },
    {
      "n",
      "<leader>as",
      function()
        require("sidekick.cli").select({ filter = { installed = true } })
      end,
      { desc = "Sidekick select" },
    },
    {
      "n",
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      { desc = "Sidekick detach" },
    },
    {
      { "x", "n" },
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      { desc = "Sidekick send this" },
    },
    {
      "n",
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      { desc = "Sidekick send file" },
    },
    {
      "x",
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      { desc = "Sidekick send visual selection" },
    },
    {
      { "n", "x" },
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      { desc = "Sidekick select prompt" },
    },
  },
})
