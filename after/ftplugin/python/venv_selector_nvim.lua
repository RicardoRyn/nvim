if vim.g.vscode then return end

local sys = require("utils.system")
require("venv-selector").setup({
  search = {
    anaconda_base = {
      command = sys.is_win and "fd python.exe$ E:/python/envs --max-depth 2 --full-path --color never -HI -a -L"
        or "fd /python$ ~/miniforge3/envs --max-depth 3 --full-path --color never -E /proc",
      type = "anaconda",
    },
    cwd = {
      command = sys.is_win and "fd python.exe$ $CWD/.venv/Scripts --full-path --color never -HI -a -L"
        or "fd '/bin/python$' $CWD --full-path --color never -E /proc -I -a -L",
    },
  },
})

vim.keymap.set("n", "<leader>lv", "<cmd>VenvSelect<CR>", { desc = "Virtual Env" })
