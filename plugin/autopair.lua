if vim.g.vscode then return end

local function get_next_char()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  return line:sub(col, col)
end

local function get_prev_char()
  local col = vim.fn.col(".")
  local line = vim.fn.getline(".")
  return line:sub(col - 1, col - 1)
end

local pair_map = {
  ["("] = ")",
  ["["] = "]",
  ["{"] = "}",
  ['"'] = '"',
  ["'"] = "'",
  ["`"] = "`",
}

-- auto pairing
for open, close in pairs(pair_map) do
  vim.keymap.set("i", open, function()
    if open == "`" then
      local col = vim.fn.col(".")
      local line = vim.fn.getline(".")
      -- check if the two characters before the cursor are "``" and the one before that is not "`"
      -- add a safeguard: ensure that the character before those two is not a backtick
      -- to prevent infinite generation when pressing more than 4 times in a row
      if line:sub(col - 2, col - 1) == "``" and line:sub(col - 3, col - 3) ~= "`" then
        return "````<Left><Left><Left>"
      end
    end

    -- for quotes (open == close)
    if open == close and get_next_char() == close then
      return "<Right>"
    end
    return open .. close .. "<Left>"
  end, { expr = true, remap = false })

  -- for brackets (open ~= close)
  if open ~= close then
    vim.keymap.set("i", close, function()
      if get_next_char() == close then
        return "<Right>"
      else
        return close
      end
    end, { expr = true, remap = false })
  end
end

-- smart <BS>
vim.keymap.set("i", "<BS>", function()
  local left = get_prev_char()
  local right = get_next_char()

  if pair_map[left] == right then
    return "<Del><BS>"
  end
  return "<BS>"
end, { expr = true, remap = false })

-- smart <CR>
vim.keymap.set("i", "<CR>", function()
  -- 1. check if the completion menu is visible
  if vim.fn.pumvisible() == 1 then
    local info = vim.fn.complete_info({ "selected" })
    if info.selected ~= -1 then
      -- 2. if an item is selected, confirm it
      return "<C-y>"
    else
      -- 3. if not, exit the completion menu (<C-e>) and immediately insert a newline (<CR>)
      return "<C-e><CR>"
    end
  end
  -- if the characters on both sides of the cursor are matching pairs, insert a newline and indent between them
  local left = get_prev_char()
  local right = get_next_char()
  if (left == "{" and right == "}") or (left == "[" and right == "]") or (left == "(" and right == ")") then
    return "<CR><Esc>O"
  end
  return "<CR>"
end, { expr = true, replace_keycodes = true })
