-- ============================================================================
-- General Keymaps (All Modes)
-- ============================================================================

-- stylua: ignore start
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set("v", "U", "<Nop>", { desc = "Disable U in visual mode" })
vim.keymap.set("v", "u", "<Nop>", { desc = "Disable u in visual mode" })
vim.keymap.set( "n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
vim.keymap.set({ "n", "v" }, "x", "<Nop>", { desc = "Reserved for hop.nvim" })
vim.keymap.set({ "n", "v" }, "E", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "v" }, "B", "^", { desc = "Go to beginning of line" })

-- ============================================================================
-- VSCode Neovim Extension Keymaps
-- ============================================================================
-- stylua: ignore start
if vim.g.vscode then
  vim.keymap.set("n", "<leader>ff", "<Cmd>lua require('vscode').call('workbench.action.quickOpenWithModes')<CR>", { desc = "Find Files" })
  vim.keymap.set("n", "<leader><space>", "<Cmd>lua require('vscode').call('workbench.action.quickOpenWithModes')<CR>", { desc = "Find Files" })
  vim.keymap.set("n", "<C-h>", "<Cmd>lua require('vscode').call('workbench.action.navigateLeft')<CR>", { desc = "Navigate Left" })
  vim.keymap.set("n", "<C-l>", "<Cmd>lua require('vscode').call('workbench.action.navigateRight')<CR>", { desc = "Navigate Right" })
  vim.api.nvim_exec2("nmap j gj", { output = false })
  vim.api.nvim_exec2("nmap k gk", { output = false })
  vim.keymap.set({ "n", "v" }, "<leader>aa", "<Cmd>lua require('vscode').call('workbench.action.toggleAuxiliaryBar')<CR>", { desc = "Toggle Auxiliary Bar" })
  vim.keymap.set("n", "u", "<Cmd>lua require('vscode').call('undo')<CR>", { desc = "Undo" })
  vim.keymap.set("n", "<C-r>", "<Cmd>lua require('vscode').call('redo')<CR>", { desc = "Redo" })
  vim.keymap.set("v", "<leader>lf", "<Cmd>lua require('vscode').call('editor.action.formatSelection')<CR>", { desc = "Format Selection" })
  vim.keymap.set("n", "<leader>lf", "<Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>", { desc = "Format Document" })
  vim.keymap.set("n", "<leader>lr", "<Cmd>lua require('vscode').call('editor.action.rename')<CR>", { desc = "Rename Symbol" })
  vim.keymap.set("n", "]d", "<Cmd>lua require('vscode').call('editor.action.marker.next')<CR>", { desc = "Next Diagnostic" })
  vim.keymap.set("n", "[d", "<Cmd>lua require('vscode').call('editor.action.marker.prev')<CR>", { desc = "Previous Diagnostic" })
  vim.keymap.set("n", "<leader>oo", "<Cmd>lua require('vscode').call('outline.focus')<CR>", { desc = "Focus Outline" })
  vim.keymap.set("n", "<leader>ov", "<Cmd>lua require('vscode').call('outline.toggleVisibility')<CR>", { desc = "Toggle Outline" })
  vim.keymap.set("n", "za", "<Cmd>lua require('vscode').call('editor.toggleFold')<CR>", { desc = "Toggle Fold" })
  vim.keymap.set("n", "L", "<Cmd>lua require('vscode').call('workbench.action.nextEditor')<CR>", { desc = "Next Buffer" })
  vim.keymap.set("n", "H", "<Cmd>lua require('vscode').call('workbench.action.previousEditor')<CR>", { desc = "Previous Buffer" })
  vim.keymap.set("n", "<leader>bd", "<Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>", { desc = "Close Buffer" })
  vim.keymap.set("n", "<leader>bo", "<Cmd>lua require('vscode').call('workbench.action.closeOtherEditors')<CR>", { desc = "Close Other Buffers" })
  vim.keymap.set("n", "<leader>bl", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheLeft')<CR>", { desc = "Close Buffers Left" })
  vim.keymap.set("n", "<leader>br", "<Cmd>lua require('vscode').call('workbench.action.closeEditorsToTheRight')<CR>", { desc = "Close Buffers Right" })
  vim.keymap.set("n", "<leader>ba", "<Cmd>lua require('vscode').call('workbench.action.closeAllEditors')<CR>", { desc = "Close All Buffers" })
  vim.keymap.set("n", "<leader>b<", "<Cmd>lua require('vscode').call('workbench.action.moveEditorLeftInGroup')<CR>", { desc = "Move Buffer Left" })
  vim.keymap.set("n", "<leader>b>", "<Cmd>lua require('vscode').call('workbench.action.moveEditorRightInGroup')<CR>", { desc = "Move Buffer Right" })
  vim.keymap.set("n", "<leader>e", "<Cmd>lua require('vscode').call('workbench.action.toggleSidebarVisibility')<CR>", { desc = "Toggle Sidebar" })
  vim.keymap.set("n", "<leader>a", "<Cmd>lua require('vscode').call('workbench.action.toggleActivityBarVisibility')<CR>", { desc = "Toggle Activity Bar" })
  vim.keymap.set("n", "<leader>uz", "<Cmd>lua require('vscode').call('workbench.action.toggleZenMode')<CR>", { desc = "Toggle Zen Mode" })

-- ============================================================================
-- Neovim Standalone Keymaps
-- ============================================================================
else
  vim.keymap.set({ "i" }, "jk", "<Esc>", { desc = "Exit insert mode" })
  vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Next visual line" })
  vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Previous visual line" })
  vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "Next actual line" })
  vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "Previous actual line" })
  vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
  vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from system clipboard" })
  if SYSTEM.is_win then
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate Left", remap = true })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate Down", remap = true })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate Up", remap = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate Right", remap = true })
  end
end

-- ============================================================================
-- Neovide-Specific Keymaps
-- ============================================================================
-- stylua: ignore end
if vim.g.neovide then
  -- Paste from system clipboard (works in all modes)
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { noremap = true, silent = true, desc = "Paste from system clipboard" })
end
