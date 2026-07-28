require("mini.misc").safely("later", function()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      selection_modes = {
        ["@function.outer"] = "v",
        ["@loop.outer"] = "v",
        ["@conditional.outer"] = "v",
        ["@class.outer"] = "v",
        ["@parameter.outer"] = "v",
      },
      include_surrounding_whitespace = false,
    },
    move = { set_jumps = true },
  })

  -- SELECT
  local ts_select = require("nvim-treesitter-textobjects.select")
  local select_maps = {
    -- base
    ["af"] = { query = "@function.outer", desc = "around function" },
    ["if"] = { query = "@function.inner", desc = "inner function" },
    ["ac"] = { query = "@class.outer", desc = "around class" },
    ["ic"] = { query = "@class.inner", desc = "inner class" },
    -- logic
    ["ad"] = { query = "@conditional.outer", desc = "around con[d]itional" },
    ["id"] = { query = "@conditional.inner", desc = "inner con[d]itional" },
    ["ao"] = { query = "@loop.outer", desc = "around l[o]op" },
    ["io"] = { query = "@loop.inner", desc = "inner l[o]op" },
    -- markdown code block
    ["ak"] = { query = "@code_cell.outer", desc = "around code cell" },
    ["ik"] = { query = "@code_cell.inner", desc = "inner code cell" },
    -- assignment
    ["ass"] = { query = "@assignment.outer", desc = "around a[s]signment" },
    ["iss"] = { query = "@assignment.inner", desc = "inner a[s]signment" },
    ["isl"] = { query = "@assignment.lhs", desc = "inner Left-Hand side" },
    ["isr"] = { query = "@assignment.rhs", desc = "inner Right-Hand side" },
    -- fold
    ["iz"] = { query = "@fold", desc = "around fold", source = "folds" },
    ["az"] = { query = "@fold", desc = "around fold", source = "folds" },
  }
  for lhs, opt in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, lhs, function()
      ts_select.select_textobject(opt.query, opt.source or "textobjects")
    end, { desc = opt.desc })
  end

  -- MOVE
  local ts_move = require("nvim-treesitter-textobjects.move")
  local move_maps = {
    ["f"] = { query = "@function.outer", desc = "function" },
    ["o"] = { query = { "@loop.inner", "@loop.outer" }, desc = "l[o]op" },
    ["d"] = { query = { "@conditional.inner", "@conditional.outer" }, desc = "co[n]ditional" },
    ["c"] = { query = "@class.outer", desc = "class" },
    ["k"] = { query = "@code_cell.outer", desc = "code cell" },
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

  -- REPEAT
  -- f/F/t/T are handled by mini.jump
  local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
end)
