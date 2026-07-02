vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable
vim.keymap.set({ "n", "v" }, "x", "<Nop>", { desc = "Reserved for hop.nvim" })
vim.keymap.set({ "n", "v" }, "s", "<Nop>", { desc = "Reserved for persistence.nvim" })
vim.keymap.set("v", "U", "<Nop>", { desc = "Disable U in visual mode" })
vim.keymap.set("v", "u", "<Nop>", { desc = "Disable u in visual mode" })

-- Shared
vim.keymap.set("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "UI redraw" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })
vim.keymap.set({ "n", "v" }, "E", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "v" }, "B", "^", { desc = "Go to beginning of line" })

if not vim.g.vscode then
  -- General
  vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
  vim.keymap.set("i", "<C-v>", "<C-r>+", { noremap = true, silent = true, desc = "Paste from system clipboard" })
  vim.keymap.set({ "i" }, "jk", "<Esc>", { desc = "Exit insert mode" })
  vim.keymap.set({ "n", "v" }, "j", "gj", { desc = "Next visual line" })
  vim.keymap.set({ "n", "v" }, "k", "gk", { desc = "Previous visual line" })
  vim.keymap.set({ "n", "v" }, "gj", "j", { desc = "Next actual line" })
  vim.keymap.set({ "n", "v" }, "gk", "k", { desc = "Previous actual line" })
  vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down in visual mode" })
  vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up in visual mode" })

  -- Navigate
  vim.keymap.set("n", "<C-Up>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
  vim.keymap.set("n", "<C-Down>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
  vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
  vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })
  vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate Left", remap = true })
  vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate Down", remap = true })
  vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate Up", remap = true })
  vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate Right", remap = true })

  -- Scroll
  local function scroll_mode(initial_key)
    -- Number of columns to scroll per key press; adjust as needed
    local step = 5
    -- Excute the initial scroll command
    vim.cmd("normal! " .. initial_key)
    vim.cmd("redraw")
    vim.api.nvim_echo({
      { "[Scroll Mode] ", "WarningMsg" },
      { "Press h/l repeatedly to scroll left/right; any other key exits.", "Normal" },
    }, false, {})
    while true do
      local ok, char = pcall(vim.fn.getcharstr)
      -- If user presses Esc (ASCII code 27) or interrupts (Ctrl+C), exit silently
      if not ok or char == "\27" then
        vim.cmd("echo ''")
        break
      end
      -- Detect key press and trigger continuous scrolling
      if char == "h" then
        vim.cmd("normal! " .. step .. "zh")
        vim.cmd("redraw")
      elseif char == "l" then
        vim.cmd("normal! " .. step .. "zl")
        vim.cmd("redraw")
      elseif char == "H" then
        vim.cmd("normal! " .. step .. "zH")
        vim.cmd("redraw")
      elseif char == "L" then
        vim.cmd("normal! " .. step .. "zL")
        vim.cmd("redraw")
      else
        -- Clear the message and exit scroll mode on any other key press
        vim.cmd("echo ''")
        vim.api.nvim_feedkeys(char, "i", false)
        break
      end
    end
  end
  vim.keymap.set("n", "zh", function() scroll_mode("zh") end, { desc = "Scroll left" })
  vim.keymap.set("n", "zl", function() scroll_mode("zl") end, { desc = "Scroll right" })
  vim.keymap.set("n", "zH", function() scroll_mode("zH") end, { desc = "Scroll left half screen" })
  vim.keymap.set("n", "zL", function() scroll_mode("zL") end, { desc = "Scroll right half screen" })

  -- Undotree
  vim.keymap.set("n", "<leader>su", function()
    vim.cmd([[packadd nvim.undotree]])
    require("undotree").open()
  end, { desc = "Undotree" })
else
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
end

if vim.g.neovide then
  -- Paste from system clipboard (works in all modes)
  vim.keymap.set({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end, { noremap = true, silent = true, desc = "Paste from system clipboard" })
end
