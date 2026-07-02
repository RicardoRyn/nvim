local function _format_labels(opts)
  if opts.match.label2 then
    return {
      { opts.match.label1, "FlashLabel" },
      { opts.match.label2, "FlashMatch" },
    }
  else
    return {
      { opts.match.label1, "FlashLabel" },
    }
  end
end

local function _filter_folded_matches(matches)
  for i = #matches, 1, -1 do
    local line = matches[i].pos[1]
    local fold_start = vim.fn.foldclosed(line)
    if fold_start ~= -1 and fold_start ~= line then
      table.remove(matches, i)
    end
  end
end

local function _second_phase_jump(match, state, format_fn, label_opts)
  label_opts = label_opts or {}
  local Flash = require("flash")
  state:hide()
  Flash.jump({
    search = { max_length = 0 },
    highlight = { matches = false },
    label = vim.tbl_deep_extend("force", { format = format_fn }, label_opts),
    matcher = function(win)
      return vim.tbl_filter(function(m)
        return m.label1 == match.label1 and m.win == win
      end, state.results)
    end,
    labeler = function(matches)
      for _, m in ipairs(matches) do
        m.label1 = m.label2
        m.label2 = nil
        m.label = m.label1
      end
    end,
  })
end

local function jump_to_a_line(direction)
  direction = direction or "up"
  local Flash = require("flash")

  -- calc the viable lines
  local top = vim.fn.line("w0")
  local bottom = vim.fn.line("w$")
  local visible = bottom - top

  -- calc the head char
  local h = visible <= 26 and 0 or math.min(26, math.ceil((visible - 26) / 25))

  Flash.jump({
    search = { mode = "search", max_length = 0, multi_window = false },
    label = { after = { 0, 0 }, uppercase = false, format = _format_labels },
    pattern = "^",
    action = function(match, state)
      if match.label2 then
        _second_phase_jump(match, state, _format_labels, { after = { 0, -1 } })
      else
        state:hide()
        vim.api.nvim_win_set_cursor(match.win, { match.pos[1], match.pos[2] })
      end
    end,
    labeler = function(matches, state)
      _filter_folded_matches(matches)

      local labels = state:labels()
      local n = #matches
      local cursor_line = vim.fn.line(".")

      -- Build ordered indices: priority direction first (closest to cursor), then the rest
      local ordered = {}
      local primary = {} -- lines in the target direction
      local secondary = {} -- lines in the opposite direction

      if direction == "up" then
        for i = 1, n do
          if matches[i].pos[1] <= cursor_line then
            table.insert(primary, i)
          else
            table.insert(secondary, i)
          end
        end
        -- Reverse primary: closest to cursor first (matches are sorted ascending by line)
        for i = #primary, 1, -1 do
          table.insert(ordered, primary[i])
        end
        -- Secondary: below cursor, already in ascending order
        for _, idx in ipairs(secondary) do
          table.insert(ordered, idx)
        end
      else -- "down"
        for i = 1, n do
          if matches[i].pos[1] >= cursor_line then
            table.insert(primary, i)
          else
            table.insert(secondary, i)
          end
        end
        -- Primary: below cursor, already ascending (closest to cursor first)
        for _, idx in ipairs(primary) do
          table.insert(ordered, idx)
        end
        -- Reverse secondary: closest to cursor first (above cursor lines)
        for i = #secondary, 1, -1 do
          table.insert(ordered, secondary[i])
        end
      end

      -- Assign single-char labels to priority matches first
      local single_count = math.min(26 - h, n)
      for i = 1, single_count do
        local mi = ordered[i]
        matches[mi].label1 = labels[i]
        matches[mi].label2 = nil
        matches[mi].label = labels[i]
      end

      -- Assign double-char labels to remaining matches
      local idx = single_count + 1
      for header_i = 26 - h + 1, 26 do
        local header = labels[header_i]
        for second_i = 1, 26 do
          if idx > n then
            break
          end
          local mi = ordered[idx]
          matches[mi].label1 = header
          matches[mi].label2 = labels[second_i]
          matches[mi].label = header
          idx = idx + 1
        end
      end
    end,
  })
end

local function two_char_jump(opts)
  opts = opts or {}
  local target = opts.target or "start" -- "start" or "end"
  local Flash = require("flash")

  -- Patterns for word boundaries
  -- Beginnings: match the first char of each word segment, plus end of line
  -- Handles: start of line, after whitespace, after non-word chars, after underscore (snake_case), camelCase transitions
  local beginnings_pattern = [[\v((^|\s|\W)\zs\w|_\zs\w|\l\zs\u|$)]]
  -- Endings: match the last char of each word segment, plus end of line
  local endings_pattern = [[\v(\w\ze(\W|_)|\l\ze\u|$)]]
  local pattern = target == "end" and endings_pattern or beginnings_pattern

  Flash.jump({
    search = { mode = "search", multi_window = false },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = _format_labels },
    pattern = pattern,
    action = function(match, state)
      _second_phase_jump(match, state, _format_labels)
    end,
    labeler = function(matches, state)
      _filter_folded_matches(matches)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end

require("utils.lazy").load({
  setup = function()
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ff007c", bold = true })
    require("flash").setup({
      labels = "asdghklqwertyuiopzxcvbnmfj",
      prompt = {
        prefix = { { " FlashSearch: ", "FlashPromptIcon" } },
      },
      search = { mode = "fuzzy" },
      jump = {
        pos = "end",
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { { "n", "x", "o" }, "f", "f", { remap = true } },
    { { "n", "x", "o" }, "F", "F", { remap = true } },
    { { "n", "x", "o" }, "t", "t", { remap = true } },
    { { "n", "x", "o" }, "T", "T", { remap = true } },
    { { "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" } },
    { { "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" } },
    { "o", "r", function() require("flash").remote() end, { desc = "Remote Flash" } },
    { { "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" } },
    { { "c" }, "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" } },
    { { "n", "v" }, "xh", function () two_char_jump({ target = "start" }) end, { desc = "Jump to word start" } },
    { { "n", "v" }, "xl", function () two_char_jump({ target = "end" }) end, { desc = "Jump to word end" } },
    { { "n", "v" }, "xj", function() jump_to_a_line("down") end, { desc = "Go to line below" } },
    { { "n", "v" }, "xk", function() jump_to_a_line("up") end, { desc = "Go to line above" } },
    { { "n", "v" }, "xw", function() require("flash").jump({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Words" } },
    { { "n", "v" }, "xr", function() require("flash").jump({ continue = true }) end, { desc = "Resume" } },
  },
})
