if vim.g.vscode then
  return
end

require("mini.misc").safely("later", function()
  local hipatterns = require("mini.hipatterns")

  vim.api.nvim_set_hl(0, "MiniHipatternsFix", { fg = "#eff1f5", bg = "#d20f39", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { fg = "#eff1f5", bg = "#f55e44", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsWarn", { fg = "#4c4f69", bg = "#df8e1d", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsHack", { fg = "#4c4f69", bg = "#df8e1d", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsPerf", { fg = "#eff1f5", bg = "#6a2cbc", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTest", { fg = "#4c4f69", bg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsSetting", { fg = "#4c4f69", bg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTog", { fg = "#4c4f69", bg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsNote", { fg = "#eff1f5", bg = "#179299", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsFixBody", { fg = "#d20f39", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTodoBody", { fg = "#f55e44", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsWarnBody", { fg = "#df8e1d", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsHackBody", { fg = "#df8e1d", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsPerfBody", { fg = "#6a2cbc", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTestBody", { fg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsSettingBody", { fg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsTogBody", { fg = "#04a5e5", bold = true })
  vim.api.nvim_set_hl(0, "MiniHipatternsNoteBody", { fg = "#179299", bold = true })

  hipatterns.setup({
    highlighters = {
      fix = { pattern = "() FIX():", group = "MiniHipatternsFix" },
      todo = { pattern = "() TODO():", group = "MiniHipatternsTodo" },
      warn = { pattern = "() WARN():", group = "MiniHipatternsWarn" },
      hack = { pattern = "() HACK():", group = "MiniHipatternsHack" },
      perf = { pattern = "() PERF():", group = "MiniHipatternsPerf" },
      test = { pattern = "() TEST():", group = "MiniHipatternsTest" },
      setting = { pattern = "() SETTING():", group = "MiniHipatternsSetting" },
      tog = { pattern = "() TOG():", group = "MiniHipatternsTog" },
      note = { pattern = "() NOTE():", group = "MiniHipatternsNote" },
      fix_colon = { pattern = " FIX():()", group = "MiniHipatternsFix" },
      todo_colon = { pattern = " TODO():()", group = "MiniHipatternsTodo" },
      warn_colon = { pattern = " WARN():()", group = "MiniHipatternsWarn" },
      hack_colon = { pattern = " HACK():()", group = "MiniHipatternsHack" },
      perf_colon = { pattern = " PERF():()", group = "MiniHipatternsPerf" },
      test_colon = { pattern = " TEST():()", group = "MiniHipatternsTest" },
      setting_colon = { pattern = " SETTING():()", group = "MiniHipatternsSetting" },
      tog_colon = { pattern = " TOG():()", group = "MiniHipatternsTog" },
      note_colon = { pattern = " NOTE():()", group = "MiniHipatternsNote" },
      fix_body = { pattern = " FIX:().*()", group = "MiniHipatternsFixBody" },
      todo_body = { pattern = " TODO:().*()", group = "MiniHipatternsTodoBody" },
      warn_body = { pattern = " WARN:().*()", group = "MiniHipatternsWarnBody" },
      hack_body = { pattern = " HACK:().*()", group = "MiniHipatternsHackBody" },
      perf_body = { pattern = " PERF:().*()", group = "MiniHipatternsPerfBody" },
      test_body = { pattern = " TEST:().*()", group = "MiniHipatternsTestBody" },
      setting_body = { pattern = " SETTING:().*()", group = "MiniHipatternsSettingBody" },
      tog_body = { pattern = " TOG:().*()", group = "MiniHipatternsTogBody" },
      note_body = { pattern = " NOTE:().*()", group = "MiniHipatternsNoteBody" },
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

--  FIX: aaa bbb ccc
--  TODO: aaa bbb ccc
--  WARN: aaa bbb ccc
--  HACK: aaa bbb ccc
--  PERF: aaa bbb ccc
--  TEST: aaa bbb ccc
--  TOG: aaa bbb ccc
--  SETTING: aaa bbb ccc
--  NOTE: aaa bbb ccc
