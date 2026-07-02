if vim.g.vscode then return end

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local load = require("utils.lazy").load({
  setup = function()
    require("ufo").setup({
      preview = {
        win_config = { border = "rounded", winhighlight = "Normal:Folded", winblend = 0 },
        mappings = { scrollU = "<C-u>", scrollD = "<C-d>", jumpTop = "[", jumpBot = "]" },
      },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
    })
  end,
  keys = {
    { "n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds (ufo)" } },
    { "n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds (ufo)" } },
    { "n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except kinds" } },
    { "n", "zm", function() require("ufo").closeFoldsWith(0) end, { desc = "Close folds with 0" } },
    { "n", "zp", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        if vim.fn.exists(":CocActionAsync") == 2 then
          vim.fn.CocActionAsync("definitionHover") -- coc.nvim
        else
          vim.lsp.buf.hover()
        end
      end
    end, { desc = "Peek fold or show hover" } },
  },
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("SetupNvimUfo", { clear = true }),
  once = true,
  callback = load,
})
