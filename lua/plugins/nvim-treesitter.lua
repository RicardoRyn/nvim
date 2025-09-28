-- PERF: master分支的treesitter，不再维护
return {
  "nvim-treesitter/nvim-treesitter",
  cond = not vim.g.vscode,
  main = "nvim-treesitter.configs",
  branch = "master", -- 详见本系列的附录
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  opts = {
    ensure_installed = { "lua", "python", "bash", "json", "markdown", "markdown_inline", "rust" },
    highlight = { enable = true },
    indent = { enable = true },
    fold = { enable = true },

    -- jupyter notebook相关
    textobjects = {
      move = {
        enable = true,
        set_jumps = false, -- you can change this if you want.
        goto_next_start = {
          ["]c"] = { query = "@code_cell.inner", desc = "Next Code Block" },
        },
        goto_next_end = {
          ["]C"] = { query = "@code_cell.inner", desc = "Next Code Block" },
          ["gl"] = { query = "@code_cell.inner", desc = "Cell End" },
        },
        goto_previous_start = {
          ["[c"] = { query = "@code_cell.inner", desc = "Previous Code Block" },
          ["gh"] = { query = "@code_cell.inner", desc = "Cell Start" },
        },
      },
      select = {
        enable = true,
        lookahead = true, -- you can change this if you want
        keymaps = {
          ["ic"] = { query = "@code_cell.inner", desc = "in block" },
          ["ac"] = { query = "@code_cell.outer", desc = "around block" },
        },
      },
      swap = { -- Swap only works with code blocks that are under the same
        -- markdown header
        enable = true,
        swap_next = { ["<leader>msl"] = "@code_cell.outer" },
        swap_previous = { ["<leader>msh"] = "@code_cell.outer" },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    -- HACK: 先向上移动一行，再使用[C可以稳定跳转到上一个cell的末尾
    local textobj_move = require("nvim-treesitter.textobjects.move")
    local function previous_code_block()
      vim.api.nvim_command("normal! k")
      textobj_move.goto_previous_end("@code_cell.inner")
    end
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set("n", "[C", previous_code_block, {
          desc = "Previous Code Block (stable)",
        })
      end,
    })
  end,
}

-- -- PERF: main分支的nvim-treesitter
-- return {
--
--   "nvim-treesitter/nvim-treesitter",
--   branch = "main",
--   config = function()
--       local nvim_treesitter = require "nvim-treesitter"
--       nvim_treesitter.setup()
--
--       local ensure_installed = { "lua", "toml" }
--       local pattern = {}
--       for _, parser in ipairs(ensure_installed) do
--           -- neovim 自己的 api，找不到这个 parser 会报错
--           local has_parser, _ = pcall(vim.treesitter.language.inspect, parser)
--
--           if not has_parser then
--               -- install 是 nvim-treesitter 的新 api，默认情况下无论是否安装 parser 都会执行，所以这里我们做一个判断
--               nvim_treesitter.install(parser)
--           else
--               -- 新版本需要手动启动高亮，但没有安装相应 parser会导致报错
--               pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
--           end
--       end
--       vim.api.nvim_create_autocmd("FileType", {
--           pattern = pattern,
--           callback = function()
--               vim.treesitter.start()
--           end,
--       })
--       -- VeryLazy 晚于 FileType，所以需要手动触发一下
--       vim.api.nvim_exec_autocmds("FileType", {})
--   end,
-- }
