return {
  "quarto-dev/quarto-nvim",
  cond = function()
    return vim.loop.os_uname().sysname == "Windows_NT" and not vim.g.vscode
  end,
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
    -- keymap = {
    --   hover = "K",
    --   definition = "gd",
    --   rename = "<leader>rn",
    --   references = "gr",
    --   format = "<leader>gf",
    -- },
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
        map("n", "<C-CR>", runner.run_cell, { desc = "Run Cell", silent = true })
        map("n", "<leader>qa", runner.run_above, { desc = "Run Cell and Above", silent = true })
        map("n", "<leader>qA", runner.run_all, { desc = "Run All Cells", silent = true })
        map("n", "<leader>ql", runner.run_line, { desc = "Run Line", silent = true })
        map("v", "<leader>q", runner.run_range, { desc = "Quarto Run (visual selection)", silent = true })
        -- map("n", "<leader>QA", function()
        --   runner.run_all(true)
        -- end, { desc = "Run All Cells of All Languages", silent = true })
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
      name = "Quarto Hydra",
      hint = [[
      _j_/_k_: move down/up
      _r_: run cell
      _R_: run above
      _l_: run line
      _<esc>_/_q_: exit]],
      config = {
        color = "pink",
        invoke_on_body = true,
        hint = {
          position = "bottom-right",
          float_opts = {
            border = "rounded", -- you can change the border if you want
          },
        },
      },
      mode = { "n" },
      body = "<leader>j", -- this is the key that triggers the hydra
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
