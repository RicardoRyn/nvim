-- NOTE: Neovim和Vscode都生效的设置
vim.keymap.set("n", "<leader>h", "<cmd>:noh<cr>", { desc = "No Highlight" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set({ "v" }, "U", "<Nop>")
vim.keymap.set({ "v" }, "u", "<Nop>")
-- vim.keymap.set({ "n", "v" }, "J", "<Nop>")


-- stylua: ignore
if vim.g.vscode then
  -- NOTE: Vscode中生效的设置

  -- general
  vim.keymap.set( "n", "<leader>ff", "<Cmd>lua require('vscode').call('workbench.action.quickOpenWithModes')<CR>", { desc = "Find Files" })
  vim.keymap.set( "n", "<leader>uz", "<Cmd>lua require('vscode').call('workbench.action.toggleZenMode')<CR>", { desc = "Zen Mode" })
  vim.keymap.set( "n", "<leader>oo", "<Cmd>lua require('vscode').call('outline.focus')<CR>", { desc = "Outline" })
  vim.keymap.set( "n", "<leader>ov", "<Cmd>lua require('vscode').call('outline.toggleVisibility')<CR>", { desc = "Outline Visibility" })
  -- 以下两项既需要在此处设置，也需要在vscode的快捷键中设置
  vim.keymap.set( "n", "<C-h>", "<Cmd>lua require('vscode').call('workbench.action.navigateLeft')<CR>", { desc = "Move to left window" })
  vim.keymap.set( "n", "<C-l>", "<Cmd>lua require('vscode').call('workbench.action.navigateRight')<CR>", { desc = "Move to right window" })


  -- Code
  vim.api.nvim_exec2("nmap j gj", { output = false })
  vim.api.nvim_exec2("nmap k gk", { output = false })
  vim.keymap.set("n", "u", "<Cmd>lua require('vscode').call('undo')<CR>", { desc = "Undo" })
  vim.keymap.set("n", "<C-r>", "<Cmd>lua require('vscode').call('redo')<CR>", { desc = "Redo" })
  vim.keymap.set( "v", "<leader>cf", "<Cmd>lua require('vscode').call('editor.action.formatSelection')<CR>", { desc = "format selection" })
  vim.keymap.set( "n", "<leader>cf", "<Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>", { desc = "format selection" })
  vim.keymap.set( "n", "<leader>cr", "<Cmd>lua require('vscode').call('editor.action.rename')<CR>", { desc = "rename symbol" })
  vim.keymap.set( "n", "]d", "<Cmd>lua require('vscode').call('editor.action.marker.next')<CR>", { desc = "Go to next diagnostic" })
  vim.keymap.set( "n", "[d", "<Cmd>lua require('vscode').call('editor.action.marker.prev')<CR>", { desc = "Go to previous diagnostic" })
  vim.keymap.set("n", "<leader>o", "<Cmd>lua require('vscode').call('outline.focus')<CR>", { desc = "open outline" })

  -- 操作buffer（vscode中叫作编辑器）
  vim.keymap.set( "n", "L", "<Cmd>lua require('vscode').call('workbench.action.nextEditor')<CR>", { desc = "Next buffer" })
  vim.keymap.set( "n", "H", "<Cmd>lua require('vscode').call('workbench.action.previousEditor')<CR>", { desc = "Prev buffer" })
  vim.keymap.set( "n", "<leader>bd", "<Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>", { desc = "close buffer (VSCode)" })
  vim.keymap.set( "n", "<leader>bo", "<Cmd>lua require('vscode').call('workbench.action.closeOtherEditors')<CR>", { desc = "close other buffers (VSCode)" })
  vim.keymap.set( "n", "<leader>bl", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheLeft')<CR>", { desc = "close buffers to the left (VSCode)" })
  vim.keymap.set( "n", "<leader>br", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheRight')<CR>", { desc = "close buffers to the right (VSCode)" })
  vim.keymap.set( "n", "<leader>ba", "<Cmd>lua require('vscode').call('workbench.action.closeAllEditors')<CR>", { desc = "close all buffers (VSCode)" })
  vim.keymap.set( "n", "<leader>b<", "<Cmd>lua require('vscode').call('workbench.action.moveEditorLeftInGroup')<CR>", { desc = "Move buffer left (VSCode)" })
  vim.keymap.set( "n", "<leader>b>", "<Cmd>lua require('vscode').call('workbench.action.moveEditorRightInGroup')<CR>", { desc = "Move buffer right (VSCode)" })

  -- UI
  vim.keymap.set( "n", "<leader>e", "<Cmd>lua require('vscode').call('workbench.action.toggleSidebarVisibility')<CR>", { desc = "toggleSidebarVisibility" })
  vim.keymap.set("n", "<leader>E", "<Cmd>lua require('vscode').call('yazi-vscode.toggle')<CR>", { desc = "open yazi" })
  vim.keymap.set( "n", "<leader>a", "<Cmd>lua require('vscode').call('workbench.action.toggleActivityBarVisibility')<CR>", { desc = "toggleActivityBarVisibility" })
else
  -- NOTE: Neovim中生效的设置
  vim.keymap.set({ "i" }, "jk", "<Esc>")

  vim.keymap.set("n", "j", "gj", { desc = "gj" })
  vim.keymap.set("n", "k", "gk", { desc = "gk" })
  vim.keymap.set("n", "gj", "j", { desc = "j" })
  vim.keymap.set("n", "gk", "k", { desc = "k" })

  vim.keymap.set("n", "<C-d>", "5j", { noremap = true, silent = true, desc = "Down 5 lines" })
  vim.keymap.set("n", "<C-u>", "5k", { noremap = true, silent = true, desc = "Up 5 lines" })

  vim.keymap.set("i", "<C-h>", "<ESC>I", { desc = "Move to the beginning of the line in Insert mode" })
  vim.keymap.set("i", "<C-l>", "<ESC>A", { desc = "Move to the end of the line in Insert mode" })

  -- stylua: ignore
  vim.keymap.set("v", "<C-c>", '"+y') -- 让neovim中C-c可以复制内容到剪贴板
  vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from clipboard in insert mode" })
end

-- NOTE: Neovide中生效的设置
if vim.g.neovide then
  -- 让neovide中 ctrl+shift+v 可以粘贴剪贴板内容
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { noremap = true, silent = true })
end
