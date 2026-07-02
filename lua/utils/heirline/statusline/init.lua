local M = {}

M.cmdline = require("utils.heirline.statusline.cmdline")
M.cursor_position = require("utils.heirline.statusline.cursor_position")
M.dap_messages = require("utils.heirline.statusline.dap_messages")
M.diagnostics = require("utils.heirline.statusline.diagnostics")
M.file_name_block = require("utils.heirline.statusline.file_name_block")
M.file_others = require("utils.heirline.statusline.file_others")
M.help_file_name = require("utils.heirline.statusline.help_file_name")
M.jj = require("utils.heirline.statusline.jj")
M.lsp = require("utils.heirline.statusline.lsp")
M.terminal_name = require("utils.heirline.statusline.terminal_name")
M.vim_mode = require("utils.heirline.statusline.vim_mode")
M.work_dir = require("utils.heirline.statusline.work_dir")
M.lazy = require("utils.heirline.statusline.lazy")
M.ai = require("utils.heirline.statusline.ai")
M.python_venv = require("utils.heirline.statusline.python_venv")

return M
