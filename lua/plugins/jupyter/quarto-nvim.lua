if vim.g.vscode then
  return {}
else
  return {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvimtools/hydra.nvim",
    },
    ft = { "quarto", "markdown" }, -- 进入qmd/md文件时才加载插件
    opts = {
      lspFeatures = {
        languages = { "r", "python", "rust" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        hover = "K",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)
      require("quarto").activate()
      if opts.codeRunner.enabled then
        local ok, runner = pcall(require, "quarto.runner")
        if ok then
          local map = vim.keymap.set
          map("n", "<localleader>qc", runner.run_cell, { desc = "run cell", silent = true })
          map("n", "<localleader>qa", runner.run_above, { desc = "run cell and above", silent = true })
          map("n", "<localleader>qA", runner.run_all, { desc = "run all cells", silent = true })
          map("n", "<localleader>ql", runner.run_line, { desc = "run line", silent = true })
          map("v", "<localleader>q", runner.run_range, { desc = "run visual range", silent = true })
          map("n", "<localleader>QA", function()
            runner.run_all(true)
          end, { desc = "run all cells of all languages", silent = true })
        end
      end

      -- hydra
      local function keys(str)
        return function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
        end
      end
      local hydra = require("hydra")
      hydra({
        name = "QuartoNavigator",
        hint = [[
          _j_/_k_: move down/up  _r_: run cell
          _l_: run line  _R_: run above
          ^^     _<esc>_/_q_: exit ]],
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            border = "rounded", -- you can change the border if you want
          },
        },
        mode = { "n" },
        body = "<localleader>j", -- this is the key that triggers the hydra
        heads = {
          { "j", keys("]c") },
          { "k", keys("[c") },
          { "r", ":QuartoSend<CR>" },
          { "l", ":QuartoSendLine<CR>" },
          { "R", ":QuartoSendAbove<CR>" },
          { "<esc>", nil, { exit = true } },
          { "q", nil, { exit = true } },
        },
      })
    end,
  }
end
