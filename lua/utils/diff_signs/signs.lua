--- Use the nvim internal diff to compare the contents of the current buffer
--- with its previous commited version and calculate the location and type
--- of gutter marks to display in the buffer

local config = require("utils.diff_signs.config")

local ns = vim.api.nvim_create_namespace("diff_signs")

--- @class DiffSigns.Signs
--- @field line integer
--- @field count integer
--- @field sign string

--- return a string containing the contents of given buffer
--- @param buf integer
--- @return string
local buf_to_string = function(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local text = table.concat(lines, "\n") .. "\n"
  return text
end

--- Update buffer hunks and build a signs array
--- @param bufinfo DiffSigns.Bufinfo
--- @return DiffSigns.Signs[]
local get_signs = function(bufinfo)
  local signs = {} ---@type DiffSigns.Signs[]
  if bufinfo.prev_rev == nil then
    return signs
  end
  bufinfo.hunks =
    vim.text.diff(buf_to_string(bufinfo.prev_rev), buf_to_string(bufinfo.buf), { result_type = "indices" }) --[=[@as integer[][]]=]

  -- each hunk entry consists of four values
  -- - 1: line number in orignal buffer (unused)
  -- - 2: number of lines that differ in original buffer
  -- - 3: line number in current buffer
  -- - 4: number of lines that differ in current buffer
  for _, hunk in ipairs(bufinfo.hunks) do
    local line = hunk[3]
    if hunk[2] == 0 then
      -- addition
      table.insert(signs, { line = line, count = hunk[4], sign = config.signs.add.icon, hl = config.signs.add.hl })
    elseif hunk[4] == 0 then
      -- deletion
      if line == 0 then
        table.insert(signs, { line = 1, count = 1, sign = config.signs.topdelete.icon, hl = config.signs.topdelete.hl })
      else
        table.insert(signs, { line = line, count = 1, sign = config.signs.delete.icon, hl = config.signs.delete.hl })
      end
    else
      -- change
      table.insert(
        signs,
        { line = line, count = hunk[4], sign = config.signs.change.icon, hl = config.signs.change.hl }
      )
    end
  end

  return signs
end

--- add a sign to a buffer line
--- @param buf integer
--- @param line integer
--- @param sign string
local set_sign = function(buf, line, sign, hl)
  local opts = {
    id = line + 1,
    priority = 199,
  }
  if config.style == 'number' then
    opts.number_hl_group = hl
  else
    opts.sign_text = sign
    opts.sign_hl_group = hl
  end
  local ok, err = pcall(vim.api.nvim_buf_set_extmark, buf, ns, line - 1, 0, opts)
  if not ok then
    vim.notify("diff_signs: " .. err, vim.log.levels.ERROR)
  end
end

local M = {}

--- clear signs for the given bufinfo
--- @param bufinfo DiffSigns.Bufinfo
M.clear = function(bufinfo)
  -- the buffer may have gone away in which case there is nothing to clear
  if vim.api.nvim_buf_is_valid(bufinfo.buf) then
    vim.api.nvim_buf_clear_namespace(bufinfo.buf, ns, 0, -1)
  end
end

--- update signs for the given bufinfo
--- @param bufinfo DiffSigns.Bufinfo
M.update = function(bufinfo)
  M.clear(bufinfo)
  for _, sign in ipairs(get_signs(bufinfo)) do
    local count = sign.count - 1
    for line = sign.line, sign.line + count, 1 do
      set_sign(bufinfo.buf, line, sign.sign, sign.hl)
    end
  end
end

return M
