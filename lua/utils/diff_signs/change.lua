--- Inline diff preview using extmarks.
--- Toggle on/off: first call shows, second call hides.
---
--- A "change" is just a deletion + addition:
---   - deleted/original lines → virtual lines with DiffDelete
---   - added/current lines   → DiffAdd background

local preview_ns = vim.api.nvim_create_namespace("diff_signs_preview")
local active = {} -- { [buf] = true }

--- @param buf integer
--- @param hunks integer[][]
--- @param prev_rev integer
local function show(buf, hunks, prev_rev)
  active[buf] = true

  for _, hunk in ipairs(hunks) do
    local orig_start = hunk[1]
    local orig_count = hunk[2]
    local buf_start = hunk[3]
    local buf_count = hunk[4]

    -- Deleted/original lines → virtual lines
    if orig_count > 0 then
      local orig_lines = vim.api.nvim_buf_get_lines(
        prev_rev, orig_start - 1, orig_start - 1 + orig_count, false)
      local virt_lines = {}
      for _, line in ipairs(orig_lines) do
        virt_lines[#virt_lines + 1] = { { line, "DiffDelete" } }
      end

      local line_count = vim.api.nvim_buf_line_count(buf)
      local row, above
      if buf_count > 0 then
        -- Change: old content before the first changed line
        if buf_start <= 1 then
          row, above = 0, true
        else
          row, above = buf_start - 1, true
        end
      else
        -- Pure deletion: old content at the gap
        if buf_start == 0 then
          row, above = 0, true
        elseif buf_start == 1 then
          row, above = 0, false
        else
          row, above = math.min(buf_start, line_count - 1), true
        end
      end

      vim.api.nvim_buf_set_extmark(buf, preview_ns, row, 0, {
        virt_lines = virt_lines,
        virt_lines_above = above,
        priority = 1000,
      })

      -- When virt lines are above the first line, scroll to make them
      -- visible (same as gitsigns).
      if row == 0 and above then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes(orig_count .. "<C-y>", true, false, true),
          "nx", false
        )
      end
    end

    -- Added/current lines → line background
    if buf_count > 0 then
      for i = 0, buf_count - 1 do
        local row = buf_start - 1 + i
        vim.api.nvim_buf_set_extmark(buf, preview_ns, row, 0, {
          end_row = row + 1,
          hl_group = "DiffAdd",
          hl_eol = true,
          priority = 1000,
        })
      end
    end
  end
end

local M = {}

--- Toggle inline diff preview for a buffer.
--- @param bufinfo DiffSigns.Bufinfo
M.toggle = function(bufinfo)
  local buf = bufinfo.buf

  if active[buf] then
    vim.api.nvim_buf_clear_namespace(buf, preview_ns, 0, -1)
    active[buf] = nil
    return
  end

  if bufinfo.prev_rev == nil then return end
  if #bufinfo.hunks == 0 then return end

  show(buf, bufinfo.hunks, bufinfo.prev_rev)
end

return M
