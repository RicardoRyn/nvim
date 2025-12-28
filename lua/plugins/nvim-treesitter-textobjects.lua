return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  init = function()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
        },
        include_surrounding_whitespace = false,
      },
      move = { set_jumps = true },
    })

    -- select
    local ts_select = require("nvim-treesitter-textobjects.select")
    local select_maps = {
      -- 基础结构
      ["af"] = { query = "@function.outer", desc = "around function" },
      ["if"] = { query = "@function.inner", desc = "inner function" },
      ["ac"] = { query = "@class.outer", desc = "around class" },
      ["ic"] = { query = "@class.inner", desc = "inner class" },
      -- 逻辑控制
      ["an"] = { query = "@conditional.outer", desc = "around co[n]ditional" },
      ["in"] = { query = "@conditional.inner", desc = "inner co[n]ditional" },
      ["ao"] = { query = "@loop.outer", desc = "around l[o]op" },
      ["io"] = { query = "@loop.inner", desc = "inner l[o]op" },
      -- markdown 代码块
      ["ak"] = { query = "@code_cell.outer", desc = "around code cell" },
      ["ik"] = { query = "@code_cell.inner", desc = "inner code cell" },
      -- 赋值
      ["aa"] = { query = "@assignment.outer", desc = "around assignment" },
      ["ia"] = { query = "@assignment.inner", desc = "inner assignment" },
      ["il"] = { query = "@assignment.lhs",   desc = "inner Left-Hand side" },
      ["ir"] = { query = "@assignment.rhs",   desc = "inner Right-Hand side" },
      -- 作用域
      ["as"] = { query = "@local.scope", desc = "around scope", source = "locals" },
      -- 折叠
      ["az"] = { query = "@fold", desc = "around fold", source = "folds" },
    }
    for lhs, opt in pairs(select_maps) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        ts_select.select_textobject(opt.query, opt.source or "textobjects")
      end, { desc = opt.desc })
    end

    -- move
    local ts_move = require("nvim-treesitter-textobjects.move")
    local move_maps = {
      ["f"] = { query = "@function.outer", desc = "function" },
      ["c"] = { query = "@class.outer", desc = "class" },
      ["n"] = { query = { "@conditional.inner", "@conditional.outer" }, desc = "co[n]ditional" },
      ["o"] = { query = { "@loop.inner", "@loop.outer" }, desc = "l[o]op" },
      ["k"] = { query = "@code_cell.outer", desc = "code cell" },
      ["s"] = { query = "@local.scope", desc = "scope", source = "locals" },
      ["z"] = { query = "@fold", desc = "fold", source = "folds" },
    }
    for char, opt in pairs(move_maps) do
      local source = opt.source or "textobjects"
      vim.keymap.set({ "n", "x", "o" }, "]" .. char, function()
        ts_move.goto_next_start(opt.query, source)
      end, { desc = "Next " .. opt.desc .. " start" })
      vim.keymap.set({ "n", "x", "o" }, "]" .. char:upper(), function()
        ts_move.goto_next_end(opt.query, source)
      end, { desc = "Next " .. opt.desc .. " end" })
      vim.keymap.set({ "n", "x", "o" }, "[" .. char, function()
        ts_move.goto_previous_start(opt.query, source)
      end, { desc = "Prev " .. opt.desc .. " start" })
      vim.keymap.set({ "n", "x", "o" }, "[" .. char:upper(), function()
        ts_move.goto_previous_end(opt.query, source)
      end, { desc = "Prev " .. opt.desc .. " end" })
    end

    -- repeat
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
  end,
}
