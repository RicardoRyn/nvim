return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "VeryLazy",
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
          ["@function.outer"] = "v",
          ["@class.outer"] = "v",
          ["@conditional.outer"] = "v",
          ["@loop.outer"] = "v",
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
      ["il"] = { query = "@assignment.lhs", desc = "inner Left-Hand side" },
      ["ir"] = { query = "@assignment.rhs", desc = "inner Right-Hand side" },
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

    -- ============================================================
    -- Custom: bracket & quote textobjects  ib/ab  iq/aq
    -- Uses Lua %b balanced-pair patterns (same approach as mini.ai).
    -- ============================================================
    local N_LINES = 50 -- search radius, same as mini.ai default

    -- Build a 1D string from buffer lines around cursor (like mini.ai's
    -- get_neighborhood). Returns the joined text, cursor offset (1-indexed),
    -- and the starting buffer row of the context.
    local function build_1d_context()
      local cursor = vim.api.nvim_win_get_cursor(0)
      local crow, ccol = cursor[1], cursor[2] -- row 1-idx, col 0-idx
      local buf_lines = vim.api.nvim_buf_line_count(0)
      local from = math.max(0, crow - 1 - N_LINES)
      local to = math.min(buf_lines, crow + N_LINES)
      local lines = vim.api.nvim_buf_get_lines(0, from, to, false)
      local text = table.concat(lines, '\n')
      -- cursor offset in 1D string (1-indexed)
      local offset = 0
      for i = 1, (crow - from - 1) do
        offset = offset + #lines[i] + 1 -- +1 for \n
      end
      offset = offset + ccol + 1
      return text, offset, from + 1, lines -- from+1 = start row (1-idx)
    end

    -- Convert 1D offset back to (1-idx row, 1-idx col) relative to context start.
    local function offset_to_pos(lines, offset)
      local acc = 0
      for i, line in ipairs(lines) do
        local seg = #line + 1 -- +1 for \n
        if offset <= acc + seg then
          return i, offset - acc
        end
        acc = acc + seg
      end
      return #lines, #lines[#lines] + 1
    end

    -- Find the innermost balanced pair (among patterns) that contains
    -- cursor_offset (1-indexed) inside `text`.
    --   same_char: true for quote-like delimiters ("", '')
    --              where pairs must NOT nest (like mini.ai's is_same_balanced).
    -- Returns from, to (1-indexed offsets) or nil.
    local function find_innermost_pair(text, patterns, same_char, cursor_offset)
      local best_from, best_to, best_width = nil, nil, math.huge
      for _, pat in ipairs(patterns) do
        local init = 1
        while init <= #text do
          local f, t = string.find(text, pat, init)
          if not f then break end
          if cursor_offset >= f and cursor_offset <= t then
            local w = t - f
            if w < best_width then
              best_width, best_from, best_to = w, f, t
            end
          end
          -- Same-char delimiters ("…", '…') skip past whole match;
          -- different-char delimiters ({…}, […], (…)) step 1 forward for nesting.
          init = (same_char and t or f) + 1
        end
      end
      if best_from then
        return best_from, best_to
      end
    end

    -- Apply visual selection to a range in the buffer.
    -- start_row, start_col, end_row, end_col are 1-indexed.
    -- inner=true → exclude delimiters; inner=false → include them.
    local function select_range(srow, scol, erow, ecol, inner)
      -- Exit to normal mode first (like mini.ai's exit_to_normal_mode).
      -- Critical: if already in visual mode (`vib`), `normal! v` would exit it.
      vim.cmd('normal! \28\14') -- <C-\><C-n>
      if inner then
        vim.api.nvim_win_set_cursor(0, { srow, scol })
        vim.cmd('normal! v')
        if ecol - 2 >= scol then
          vim.api.nvim_win_set_cursor(0, { erow, ecol - 2 })
        end
      else
        vim.api.nvim_win_set_cursor(0, { srow, scol - 1 })
        vim.cmd('normal! v')
        vim.api.nvim_win_set_cursor(0, { erow, ecol - 1 })
      end
    end

    -- Shared helper: bracket or quote textobject.
    local function pair_textobj(patterns, same_char, inner)
      local text, offset, ctx_start, lines = build_1d_context()
      local f, t = find_innermost_pair(text, patterns, same_char, offset)
      if not f then return end
      local srow, scol = offset_to_pos(lines, f)
      local erow, ecol = offset_to_pos(lines, t)
      select_range(ctx_start + srow - 1, scol, ctx_start + erow - 1, ecol, inner)
    end

    -- Bracket patterns — different-char delimiters, allow nesting
    local bracket_patterns = { '%b()', '%b[]', '%b{}' }
    -- Quote patterns — same-char delimiters, no nesting
    local quote_patterns = { "%b''", '%b""' }

    vim.keymap.set({ 'x', 'o' }, 'ib', function()
      pair_textobj(bracket_patterns, false, true)
    end, { desc = 'inner bracket' })
    vim.keymap.set({ 'x', 'o' }, 'ab', function()
      pair_textobj(bracket_patterns, false, false)
    end, { desc = 'around bracket' })
    vim.keymap.set({ 'x', 'o' }, 'iq', function()
      pair_textobj(quote_patterns, true, true)
    end, { desc = 'inner quote' })
    vim.keymap.set({ 'x', 'o' }, 'aq', function()
      pair_textobj(quote_patterns, true, false)
    end, { desc = 'around quote' })

    -- repeat
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
