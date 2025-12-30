vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("v", "U", "<Nop>")
vim.keymap.set("v", "u", "<Nop>")
vim.keymap.set({ "n", "v" }, "x", "<Nop>") -- 留给hop.nvim
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- stylua: ignore
if vim.g.vscode then
  -- general
  vim.keymap.set( "n", "<leader>ff", "<Cmd>lua require('vscode').call('workbench.action.quickOpenWithModes')<CR>", { desc = "Find Files" })
  vim.keymap.set( "n", "<leader><space>", "<Cmd>lua require('vscode').call('workbench.action.quickOpenWithModes')<CR>", { desc = "Find Files" })
  -- 以下两项既需要在此处设置，也需要在vscode的快捷键中设置
  vim.keymap.set( "n", "<C-h>", "<Cmd>lua require('vscode').call('workbench.action.navigateLeft')<CR>", { desc = "Move to left window" })
  vim.keymap.set( "n", "<C-l>", "<Cmd>lua require('vscode').call('workbench.action.navigateRight')<CR>", { desc = "Move to right window" })

  -- Code
  vim.api.nvim_exec2("nmap j gj", { output = false })
  vim.api.nvim_exec2("nmap k gk", { output = false })
  vim.keymap.set({ "n", "v" }, "<leader>aa", "<Cmd>lua require('vscode').call('workbench.action.toggleAuxiliaryBar')<CR>", { desc = "Toggle Auxiliary Bar" })
  vim.keymap.set("n", "u", "<Cmd>lua require('vscode').call('undo')<CR>", { desc = "Undo" })
  vim.keymap.set("n", "<C-r>", "<Cmd>lua require('vscode').call('redo')<CR>", { desc = "Redo" })
  vim.keymap.set("v", "<leader>lf", "<Cmd>lua require('vscode').call('editor.action.formatSelection')<CR>", { desc = "format selection" })
  vim.keymap.set("n", "<leader>lf", "<Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>", { desc = "format selection" })
  vim.keymap.set("n", "<leader>lr", "<Cmd>lua require('vscode').call('editor.action.rename')<CR>", { desc = "rename symbol" })
  vim.keymap.set("n", "]d", "<Cmd>lua require('vscode').call('editor.action.marker.next')<CR>", { desc = "Go to next diagnostic" })
  vim.keymap.set("n", "[d", "<Cmd>lua require('vscode').call('editor.action.marker.prev')<CR>", { desc = "Go to previous diagnostic" })
  vim.keymap.set("n", "<leader>oo", "<Cmd>lua require('vscode').call('outline.focus')<CR>", { desc = "Open outline" })
  vim.keymap.set("n", "za", "<Cmd>lua require('vscode').call('editor.toggleFold')<CR>", { desc = "Toggle fold" })
  vim.keymap.set("n", "<leader>oo", "<Cmd>lua require('vscode').call('outline.focus')<CR>", { desc = "Outline" })
  vim.keymap.set("n", "<leader>ov", "<Cmd>lua require('vscode').call('outline.toggleVisibility')<CR>", { desc = "Outline Visibility" })

  -- Buffer
  vim.keymap.set("n", "L", "<Cmd>lua require('vscode').call('workbench.action.nextEditor')<CR>", { desc = "Next buffer" })
  vim.keymap.set("n", "H", "<Cmd>lua require('vscode').call('workbench.action.previousEditor')<CR>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<leader>bd", "<Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>", { desc = "close buffer (VSCode)" })
  vim.keymap.set("n", "<leader>bo", "<Cmd>lua require('vscode').call('workbench.action.closeOtherEditors')<CR>", { desc = "close other buffers (VSCode)" })
  vim.keymap.set("n", "<leader>bl", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheLeft')<CR>", { desc = "close buffers to the left (VSCode)" })
  vim.keymap.set("n", "<leader>br", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheRight')<CR>", { desc = "close buffers to the right (VSCode)" })
  vim.keymap.set("n", "<leader>ba", "<Cmd>lua require('vscode').call('workbench.action.closeAllEditors')<CR>", { desc = "close all buffers (VSCode)" })
  vim.keymap.set("n", "<leader>b<", "<Cmd>lua require('vscode').call('workbench.action.moveEditorLeftInGroup')<CR>", { desc = "Move buffer left (VSCode)" })
  vim.keymap.set("n", "<leader>b>", "<Cmd>lua require('vscode').call('workbench.action.moveEditorRightInGroup')<CR>", { desc = "Move buffer right (VSCode)" })

  -- UI
  vim.keymap.set("n", "<leader>e", "<Cmd>lua require('vscode').call('workbench.action.toggleSidebarVisibility')<CR>", { desc = "toggleSidebarVisibility" })
  vim.keymap.set("n", "<leader>E", "<Cmd>lua require('vscode').call('yazi-vscode.toggle')<CR>", { desc = "open yazi" })
  vim.keymap.set("n", "<leader>a", "<Cmd>lua require('vscode').call('workbench.action.toggleActivityBarVisibility')<CR>", { desc = "toggleActivityBarVisibility" })
  vim.keymap.set("n", "<leader>uz", "<Cmd>lua require('vscode').call('workbench.action.toggleZenMode')<CR>", { desc = "Zen Mode" })

else
  vim.keymap.set({ "i" }, "jk", "<Esc>")
  vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "gj" })
  vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "gk" })
  vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "j" })
  vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "k" })

  -- Copy
  vim.keymap.set("v", "<C-c>", '"+y') -- 让neovim中C-c可以复制内容到剪贴板
  vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard in insert mode" })

  -- 在非Windows上由vim-tmux-navigator.lua接管
  if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
  end
end

if vim.g.neovide then
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { noremap = true, silent = true })
end
