--- Squash the hunk under the cursor (or visual selection) from the jj working
--- change into its parent change.
---
--- jj has no staging area, so "I have reviewed this hunk" is expressed by moving
--- it into the parent change with `jj squash -i`. This module automates that for
--- a single hunk from a normal editing buffer: it builds the parent file content
--- plus only the selected hunk(s), then drives `jj squash -i` with a scripted
--- one-shot diff editor that writes that prepared content to `$output`.
---
--- Diff-editor contract of `jj squash -i --from @ --into @-`:
---   $left   = file version in the destination (@-)
---   $right  = file version in the source (@)
---   $output = desired new content of the destination; whatever is written here
---             gets squashed into the parent, the rest stays in @.

local M = {}

local TITLE = "JJ Review"

local config = {
  keymap = "<leader>gs",
  -- vim.text.diff ctxlen. 0 makes each hunk a maximal block of contiguous changed
  -- lines, matching what gitsigns-style signs show; larger values merge
  -- changes separated by <= 2*ctxlen unchanged lines into one hunk.
  diff_context = 0,
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = TITLE })
end

local function run(cmd, opts)
  return vim.system(cmd, vim.tbl_extend("keep", opts or {}, { text = true })):wait()
end

--- POSIX shell single-quote escaping.
local function shq(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

--- Split file content into lines, dropping only the final empty element
--- produced by the terminating newline.
local function split_lines(content)
  if content == "" then
    return {}
  end
  local lines = vim.split(content, "\n", { plain = true })
  if lines[#lines] == "" then
    table.remove(lines)
  end
  return lines
end

--- Compute hunks between two file contents with the builtin xdiff engine
--- (the same one hunk.nvim uses internally). No subprocess, no text parsing.
---@return { oldstart: integer, oldcount: integer, newstart: integer, newcount: integer, newlines: string[] }[]?
local function diff_hunks(parent_content, current_content)
  local indices = vim.text.diff(parent_content, current_content, {
    result_type = "indices",
    ctxlen = config.diff_context,
  })
  if type(indices) ~= "table" then
    return nil
  end
  local current_lines = split_lines(current_content)
  local hunks = {}
  for _, h in ipairs(indices) do
    local newstart, newcount = h[3], h[4]
    local newlines = {}
    for i = newstart, newstart + newcount - 1 do
      newlines[#newlines + 1] = current_lines[i]
    end
    hunks[#hunks + 1] = {
      oldstart = h[1],
      oldcount = h[2],
      newstart = newstart,
      newcount = newcount,
      newlines = newlines,
    }
  end
  return hunks
end

--- Hunks whose new-side lines overlap [first, last]. Pure deletions
--- (newcount == 0) attach to the line before/after the deleted range,
--- similar to how gitsigns maps deleted hunks.
local function collect_hunks(hunks, first, last)
  local selected = {}
  for _, h in ipairs(hunks) do
    local s, e
    if h.newcount == 0 then
      s, e = math.max(1, h.newstart), h.newstart + 1
    else
      s, e = h.newstart, h.newstart + h.newcount - 1
    end
    if s <= last and e >= first then
      selected[#selected + 1] = h
    end
  end
  return selected
end

--- parent_lines with only the selected hunks applied.
--- xdiff indices semantics: for pure insertions (oldcount == 0) oldstart is
--- the anchor line to insert *after* (0 = top of file); otherwise oldstart is
--- the first replaced/deleted line.
local function apply_hunks(parent_lines, hunks)
  local out = {}
  local pos = 1
  for _, h in ipairs(hunks) do
    if h.oldcount == 0 then
      for i = pos, h.oldstart do
        out[#out + 1] = parent_lines[i]
      end
      pos = h.oldstart + 1
    else
      for i = pos, h.oldstart - 1 do
        out[#out + 1] = parent_lines[i]
      end
      pos = h.oldstart + h.oldcount
    end
    for _, l in ipairs(h.newlines) do
      out[#out + 1] = l
    end
  end
  for i = pos, #parent_lines do
    out[#out + 1] = parent_lines[i]
  end
  return out
end

--- Resolve a revision the same way jj.nvim does (change_id, or commit_id when
--- divergent) so its `jj://<id>/<path>` scratch buffers can be matched.
local function resolve_rev_id(rev, root)
  local res = run({ "jj", "log", "--no-graph", "-r", rev, "-T", 'if(divergent, commit_id, change_id)' }, { cwd = root })
  if res.code ~= 0 then
    return nil
  end
  return vim.trim(res.stdout)
end

--- jj.nvim's open_vdiff shows the parent version in a scratch buffer named
--- `jj://<parent_id>/<relpath>`. After a squash the parent was rewritten, so
--- reload that buffer in place and recompute the diff.
local function refresh_jj_diff_views(old_parent_id, relpath, root, file_bufnr)
  if not old_parent_id then
    return
  end
  local prefix = "jj://" .. old_parent_id .. "/"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:sub(1, #prefix) == prefix and name:sub(#prefix + 1) == relpath then
      local show = run({ "jj", "file", "show", "-r", "@-", "--", relpath }, { cwd = root })
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, show.code == 0 and split_lines(show.stdout) or {})
      vim.bo[buf].modified = false
      local new_parent_id = resolve_rev_id("@-", root)
      if new_parent_id and new_parent_id ~= old_parent_id then
        pcall(vim.api.nvim_buf_set_name, buf, "jj://" .. new_parent_id .. "/" .. relpath)
      end
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.wo[win].diff then
          local wbuf = vim.api.nvim_win_get_buf(win)
          if wbuf == buf or wbuf == file_bufnr then
            vim.api.nvim_win_call(win, function()
              vim.cmd("diffupdate")
            end)
          end
        end
      end
    end
  end
end

---@param first integer 1-based first line of the region
---@param last integer 1-based last line of the region (inclusive)
local function squash_lines(first, last)
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  -- The URI-scheme check catches virtual buffers like jj.nvim's `jj://<id>/<path>`
  -- revision views, which deliberately use buftype="".
  if bufname == "" or vim.bo[bufnr].buftype ~= "" or bufname:match("^%w[%w+-.]*://") then
    return notify("Buffer is not a normal file.", vim.log.levels.WARN)
  end

  -- Resolve symlinks up front: vim.fs.relpath() compares literal prefixes and
  -- returns nil when one side is /var/... and the other /private/var/...
  local filepath = vim.uv.fs_realpath(bufname) or bufname
  local root = vim.fs.root(filepath, ".jj")
  if not root then
    return notify("Not inside a jj repository.", vim.log.levels.WARN)
  end

  -- Note: nvim 0.12 signature is relpath(base, target).
  local relpath = vim.fs.relpath(root, filepath)
  if not relpath then
    return notify("Cannot resolve path relative to the jj root.", vim.log.levels.ERROR)
  end

  -- jj snapshots the file on disk, so pending edits must be saved first.
  if vim.bo[bufnr].modified then
    local ok, err = pcall(vim.cmd, "write")
    if not ok then
      return notify("Failed to save buffer: " .. tostring(err), vim.log.levels.ERROR)
    end
  end

  local tmpdir = vim.fn.tempname()
  vim.fn.mkdir(tmpdir, "p")

  -- Destination (@-) version; a missing file means it was added in @.
  local show = run({ "jj", "file", "show", "-r", "@-", "--", relpath }, { cwd = root })
  if show.code ~= 0 and not show.stderr:match("No such path") then
    vim.fn.delete(tmpdir, "rf")
    return notify("jj file show failed:\n" .. vim.trim(show.stderr), vim.log.levels.ERROR)
  end
  local parent_content = show.code == 0 and show.stdout or ""
  local parent_lines = split_lines(parent_content)

  -- Read the file from disk (== buffer content after the save above) so the
  -- squash matches exactly what jj will snapshot.
  local fh = io.open(filepath, "rb")
  if not fh then
    vim.fn.delete(tmpdir, "rf")
    return notify("Cannot read file: " .. filepath, vim.log.levels.ERROR)
  end
  local current_content = fh:read("*a") or ""
  fh:close()

  local hunks = diff_hunks(parent_content, current_content)
  if not hunks then
    vim.fn.delete(tmpdir, "rf")
    return notify("Failed to compute diff.", vim.log.levels.ERROR)
  end
  if #hunks == 0 then
    vim.fn.delete(tmpdir, "rf")
    return notify("No changes between the parent change and this file.", vim.log.levels.WARN)
  end

  local selected = collect_hunks(hunks, first, last)
  if #selected == 0 then
    vim.fn.delete(tmpdir, "rf")
    return notify("No changed hunk under the cursor.", vim.log.levels.WARN)
  end

  -- Prepared $output tree: parent content with only the selected hunks applied.
  local out_path = tmpdir .. "/output_tree/" .. relpath
  vim.fn.mkdir(vim.fn.fnamemodify(out_path, ":h"), "p")
  vim.fn.writefile(apply_hunks(parent_lines, selected), out_path)

  -- One-shot diff editor: copy the prepared file into $output and exit.
  local script = tmpdir .. "/diff-editor.sh"
  vim.fn.writefile({
    "#!/bin/sh",
    "dest=" .. '"$3"/' .. shq(relpath),
    'mkdir -p "$(dirname "$dest")"',
    "cp " .. shq(out_path) .. ' "$dest"',
  }, script)
  vim.fn.setfperm(script, "rwxr-xr-x")

  -- Captured before the squash: afterwards @- points to a rewritten commit and
  -- jj.nvim's vdiff scratch buffer still carries the old id in its name.
  local old_parent_id = resolve_rev_id("@-", root)

  local sq = run({
    "jj", "squash", "-i",
    "--from", "@", "--into", "@-",
    "--config", string.format('ui.diff-editor=["%s","$left","$right","$output"]', script),
    "--config", "ui.diff-instructions=false",
    "--", relpath,
  }, { cwd = root })

  vim.fn.delete(tmpdir, "rf")

  if sq.code ~= 0 then
    return notify("jj squash failed:\n" .. vim.trim(sq.stderr), vim.log.levels.ERROR)
  end

  refresh_jj_diff_views(old_parent_id, relpath, root, bufnr)
  pcall(function()
    require("gitsigns").refresh(bufname)
  end)
  notify(string.format("Squashed %d hunk(s) of %s into the parent change.", #selected, relpath))
end

--- Squash the hunk under the cursor into the parent change.
function M.squash_hunk()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  squash_lines(lnum, lnum)
end

--- Squash every hunk overlapping the visual selection into the parent change.
function M.squash_hunk_range()
  local first = vim.fn.line("v")
  local last = vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  squash_lines(first, last)
end

---@param opts? { keymap?: string, diff_context?: integer }
function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})
  local lhs = config.keymap
  vim.keymap.set("n", lhs, M.squash_hunk, { desc = "Squash hunk" })
  vim.keymap.set("x", lhs, M.squash_hunk_range, { desc = "Squash selected hunks" })
end

return M
