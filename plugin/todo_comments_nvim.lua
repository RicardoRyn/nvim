if vim.g.vscode then return end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("SetupTodoComments", { clear = true }),
  once = true,
  callback = function()
    require("todo-comments").setup({
      signs = true,
      sign_priority = 199,
      keywords = {
        FIX = {
          icon = require("utils.icons").comments.fix,
          color = "error",
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
        },
        TODO = { icon = require("utils.icons").comments.todo, color = "todo", alt = { "WIP", "NEXT", "TASK" } },
        WARN = { icon = require("utils.icons").comments.warn, color = "warning", alt = { "WARNING" } },
        HACK = { icon = require("utils.icons").comments.hack, color = "warning", alt = { "XXX" } },
        PERF = {
          icon = require("utils.icons").comments.perf,
          color = "perf",
          alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
        },
        TEST = { icon = require("utils.icons").comments.test, color = "info", alt = { "TESTING", "PASSED", "FAILED" } },
        TOG = {
          icon = require("utils.icons").comments.tog,
          color = "info",
          alt = { "TOGGLE", "SETTING", "SWITCH", "CONFIG", "CONF" },
        },
        NOTE = { icon = require("utils.icons").comments.note, color = "hint", alt = { "INFO", "NB", "REF", "DOCS" } },
      },
      gui_style = { fg = "ITALIC", bg = "BOLD" },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        todo = { "#f55e44" },
        warning = { "DiagnosticWarn", "WarningMsg" },
        perf = { "#6a2cbc" },
        info = { "DiagnosticInfo", "#2563EB" },
        hint = { "DiagnosticHint", "#10B981" },
        default = { "#ff0000" },
      },
    })
  end,
})
