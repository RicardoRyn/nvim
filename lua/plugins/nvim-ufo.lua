return {
  "kevinhwang91/nvim-ufo",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = { "kevinhwang91/promise-async" },
  opts = {
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
          -- str width returned from truncate() may less than 2nd argument, need padding
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
  },
  -- stylua: ignore
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds (ufo)", },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds (ufo)", },
    { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds", },
    { "zm", function() require("ufo").closeFoldsWith(0) end, desc = "Close folds with 0", },
    { "zp",
      function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          -- choose one of coc.nvim and nvim lsp
          if vim.fn.exists(":CocActionAsync") == 2 then
            vim.fn.CocActionAsync("definitionHover") -- coc.nvim
          else
            vim.lsp.buf.hover()
          end
        end
      end,
      desc = "Peek fold or show hover",
    },
  },
  init = function()
    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,

  config = function(_, opts)
    require("ufo").setup(opts)
    -- 自定义函数，用于折叠 Markdown 代码块
    local function fold_code_cell()
      vim.api.nvim_command("normal vic")
      vim.api.nvim_command("normal zf")
    end
    vim.keymap.set("n", "<C-j><C-k>", fold_code_cell, { desc = "Fold current code cell" })
  end,
}
