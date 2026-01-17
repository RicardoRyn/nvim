return {
  "folke/sidekick.nvim",
  cond = not vim.g.vscode,
  opts = {
    nes = { enabled = false },
    cli = {
      win = {
        split = {
          width = 0.4, -- set to 0 for default split width
        },
        keys = {
          buffers = false,
          files = false,
          hide_ctrl_dot = false,
          hide_ctrl_z = false,
          prompt = false,
        },
      },
      mux = {
        backend = "tmux",
        enabled = false,
      },
      tools = {
        iflow = {
          cmd = { "iflow", "-c", "--default" },
        },
      },
      prompts = {
        -- changes = "Can you review my changes?",
        changes = "你能审查一下我的更改吗？",
        -- diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        diagnostics = "你能帮我解释 {file} 中的诊断问题吗？\n{diagnostics}",
        -- diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
        diagnostics_all = "你能帮我解释这些诊断问题吗？\n{diagnostics_all}",
        -- document = "Add documentation to {function|line}",
        document = "为 {function|line} 添加文档",
        -- explain = "Explain {this}",
        explain = "解释 {this}",
        -- fix = "Can you fix {this}?",
        fix = "你能修复 {this} 吗？",
        -- optimize = "How can {this} be optimized?",
        optimize = "如何优化 {this}？",
        -- review = "Can you review {file} for any issues or improvements?",
        review = "你能审查 {file} 中是否存在任何问题或改进空间吗？",
        -- tests = "Can you write tests for {this}?",
        tests = "你能为 {this} 编写测试吗？",
        translate = "{selection}\n将上述内容翻译成中文。",
        -- simple context prompts
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
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      -- Or to select only installed tools:
      -- require("sidekick.cli").select({ filter = { installed = true } })
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Example of a keybinding to open Claude directly
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "copilot", focus = true })
      end,
      desc = "Sidekick Toggle Copilot",
    },
    {
      "<leader>ai",
      function()
        require("sidekick.cli").toggle({ name = "iflow", focus = true })
      end,
      desc = "Sidekick Toggle iFlow",
    },
    {
      "<leader>ao",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Toggle iFlow",
    },
  },
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        picker = {
          actions = {
            sidekick_send = function(...)
              return require("sidekick.cli.picker.snacks").send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = {
                  "sidekick_send",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
      },
    },
  },
}
