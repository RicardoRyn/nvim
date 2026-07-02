local config = require("utils.diff_signs.config")
local jj = require("utils.diff_signs.jj")
local signs = require("utils.diff_signs.signs")
local change = require("utils.diff_signs.change")

--- @class DiffSigns.Bufinfo
--- @field buf integer
--- @field changed boolean
--- @field prev_rev integer?
--- @field prev_rev_id string?
--- @field hunks integer[][]

--- @class DiffSigns.Repo
--- @field name string
--- @field commit_id string
--- @field buffers DiffSigns.Bufinfo[]
--- @field handle uv.uv_fs_event_t?

---@type DiffSigns.Repo[]
local repos = {}

--- delete the prev_rev buffer if it exists
--- @param bufinfo DiffSigns.Bufinfo
local delete_prev_rev = function(bufinfo)
  if bufinfo.prev_rev ~= nil then
    vim.api.nvim_buf_delete(bufinfo.prev_rev, { force = true })
    bufinfo.prev_rev = nil
    bufinfo.prev_rev_id = nil
  end
end

--- Update prev_rev data in given bufinfo and update signs
--- @param repo_name string
--- @param bufinfo DiffSigns.Bufinfo
local update_prev_rev = function(repo_name, bufinfo)
  local file = vim.api.nvim_buf_get_name(bufinfo.buf)
  delete_prev_rev(bufinfo)
  bufinfo.prev_rev = jj.previous_version(file, repo_name)
  bufinfo.prev_rev_id = jj.previous_commit_id(repo_name)
  signs.update(bufinfo)
end

--- The repo changed but we only care if the commit_id changed. When it
--- does update the previous version of all buffers tied to the repo.
--- @param repo DiffSigns.Repo
local function check_commit_ids(repo)
  local commit_id = jj.previous_commit_id(repo.name)
  if repo.commit_id ~= commit_id then
    repo.commit_id = commit_id
    -- repo changed, update buffers
    for _, bufinfo in ipairs(repo.buffers) do
      if vim.fn.getbufinfo(bufinfo.buf)[1].hidden == 0 then
        vim.schedule(function()
          update_prev_rev(repo.name, bufinfo)
        end)
      end
    end
  end
end

--- Repo change handler
--- A repo change occurred. Update all visible buffers that refer to this repo.
--- @param name string
--- @param err string?
local on_repo_change = function(name, err)
  -- find the entry for the given name
  local repo = nil
  for _, r in ipairs(repos) do
    if r.name == name then
      repo = r
      break
    end
  end
  if repo == nil then
    return
  end

  -- check for errors
  if err ~= nil then
    repo.handle:stop()
    vim.notify("diff_signs: " .. name .. " monitoring failure", vim.log.levels.ERROR)
    return
  end

  check_commit_ids(repo)
end

--- Track repo changes
--- Add an entry to the table of repos and add an fs_event to track
--- changes.
--- @param entry DiffSigns.Repo
local track_repo = function(entry)
  table.insert(repos, entry)
  if entry.handle == nil then
    vim.notify("diff_signs: " .. entry.name .. " is not being monitored for changes", vim.log.levels.ERROR)
    return
  end

  -- track changes to the repo by monitoring its internal repo
  -- When there are changes to the repo the callback will check all
  -- associated buffers for changes.
  local root_checkout = entry.name .. "/.jj/repo"
  local ok, err = pcall(function()
    entry.handle:start(
      root_checkout,
      { recursive = false },
      vim.schedule_wrap(function(err)
        on_repo_change(entry.name, err)
      end)
    )
  end)
  if not ok then
    vim.notify("diff_signs: " .. entry.name .. " – " .. err, vim.log.levels.ERROR)
  end
end

--- a buffer was entered. If it was hidden and the repo changed the
--- previous version of the buffer may be outdated.  Check that here
--- and update the previous revision data if needed
--- @param root string
--- @param bufinfo DiffSigns.Bufinfo
local check_prev_rev = function(root, bufinfo)
  for _, repo in ipairs(repos) do
    if root == repo.name then
      if repo.commit_id ~= bufinfo.prev_rev_id then
        update_prev_rev(root, bufinfo)
      end
    end
  end
end

--- Associate a buffer with a repo.  If a repo entry does not exist
--- for the given root create an entry for the repo and start tracking
--- repo changes
--- @param bufinfo DiffSigns.Bufinfo
--- @param root string
local track_buffer = function(bufinfo, root)
  local repo = nil
  for _, r in ipairs(repos) do
    if r.name == root then
      repo = r
      break
    end
  end
  if repo == nil then
    track_repo({
      name = root,
      commit_id = jj.previous_commit_id(root),
      buffers = { bufinfo },
      handle = vim.uv.new_fs_event(),
    })
  else
    table.insert(repo.buffers, bufinfo)
  end

  -- set up three autocmds for the buffer
  -- 1) TextChanged and TextChangedI that only updates a flag in bufinfo
  -- 2) SafeState that updates signs if the flag was set.
  -- 3) BufEnter to catch up with changes that might have been made while
  --    the buffer was hidden.
  -- All commands are assigned to the same group.

  local bufgroup = vim.api.nvim_create_augroup("SetupDiffSignsBuf" .. bufinfo.buf, { clear = true })
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = bufgroup,
    buf = bufinfo.buf,
    callback = function()
      bufinfo.changed = true
    end,
  })

  vim.api.nvim_create_autocmd({ "SafeState" }, {
    group = bufgroup,
    buf = bufinfo.buf,
    callback = function()
      if bufinfo.changed then
        bufinfo.changed = false
        vim.schedule(function()
          signs.update(bufinfo)
        end)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = bufgroup,
    buf = bufinfo.buf,
    callback = function()
      vim.schedule(function()
        check_prev_rev(root, bufinfo)
      end)
    end,
  })

  signs.update(bufinfo)
end

--- find the bufinfo entry for the current buffer
--- @return DiffSigns.Bufinfo|nil
local bufinfo_for_current_buf = function()
  local buf = vim.api.nvim_win_get_buf(0)
  for _, repo in ipairs(repos) do
    for _, bufinfo in ipairs(repo.buffers) do
      if bufinfo.buf == buf then
        return bufinfo
      end
    end
  end
  return nil
end

local M = {}

--- Stop tracking all buffers.  Called when the plugin is disabled
M.stop_tracking_all = function()
  for _, repo in ipairs(repos) do
    repo.handle:stop()
    for _, bufinfo in ipairs(repo.buffers) do
      signs.clear(bufinfo)
      vim.api.nvim_del_augroup_by_name("SetupDiffSignsBuf" .. bufinfo.buf)
      delete_prev_rev(bufinfo)
    end
  end
  repos = {}
end

--- Stop tracking a buffer. If the buffer is the last buffer being tracked
--- for a repo stop tracking the repo
--- @param buf integer
M.stop_tracking = function(buf)
  for r, repo in ipairs(repos) do
    for i, bufinfo in ipairs(repo.buffers) do
      if bufinfo.buf == buf then
        signs.clear(bufinfo)
        vim.api.nvim_del_augroup_by_name("SetupDiffSignsBuf" .. bufinfo.buf)
        delete_prev_rev(bufinfo)
        table.remove(repo.buffers, i)
        if #repo.buffers == 0 then
          repo.handle:stop()
          table.remove(repos, r)
        end
        return
      end
    end
  end
end

--- Track changes to the given buffer assuming
--- - the plugin is enabled
--- - the buffer is valid
--- - the buffer type is not a special buffer
--- - there is a jj repository in the files path
--- @param buf number
--- @param file string
M.start_tracking = function(buf, file)
  if not config.enabled then
    return
  end
  if file == "" then
    return
  end
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if vim.bo[buf].buftype ~= "" then
    return
  end
  local ok, root_folder = pcall(jj.root_folder, file)
  if not ok then
    return
  end
  if root_folder == nil then
    return
  end
  -- remove the root_folder from the file name if it is there
  local repo_file = file:gsub(root_folder .. "/", "")

  -- create a bufinfo entry and track repo changes for this buffer
  --- @type DiffSigns.Bufinfo
  local bufinfo = {
    buf = buf,
    changed = false,
    prev_rev = jj.previous_version(repo_file, root_folder),
    prev_rev_id = jj.previous_commit_id(root_folder),
    hunks = {},
  }
  track_buffer(bufinfo, root_folder)
end

--- debug helper: show all the hunks for the current buffer
M.show_hunks = function()
  local bufinfo = bufinfo_for_current_buf()
  if bufinfo ~= nil then
    vim.print(vim.inspect(bufinfo.hunks))
  end
end

--- show a summary of added, changed, and deleted lines for the current buffer
M.diff = function()
  local bufinfo = bufinfo_for_current_buf()
  if bufinfo == nil then
    return
  end
  local added, changed, deleted = 0, 0, 0
  for _, hunk in ipairs(bufinfo.hunks) do
    if hunk[2] == 0 then
      added = added + hunk[4]
    elseif hunk[4] == 0 then
      deleted = deleted + hunk[2]
    else
      changed = changed + hunk[4]
    end
  end
  local diff = { added = added, changed = changed, deleted = deleted }
  return diff
end

--- position the cursor at the previous hunk in the current buffer
--- If there are no hunks position at the first line of the buffer
M.prev_hunk = function()
  local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
      return i, t[i]
    end
  end
  local function reversedipairs(t)
    return reversedipairsiter, t, #t + 1
  end

  local bufinfo = bufinfo_for_current_buf()
  if bufinfo ~= nil then
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    for _, hunk in reversedipairs(bufinfo.hunks) do
      local line = hunk[3]
      if row > line then
        vim.api.nvim_win_set_cursor(0, { line, 0 })
        return
      end
    end
  end
end

--- position the cursor at the next hunk in the current buffer
--- If there are no hunks position at the last line of the buffer
M.next_hunk = function()
  local bufinfo = bufinfo_for_current_buf()
  if bufinfo ~= nil then
    local pos = vim.api.nvim_win_get_cursor(0)
    local row = pos[1]
    for _, hunk in ipairs(bufinfo.hunks) do
      local line = hunk[3]
      if row < line then
        vim.api.nvim_win_set_cursor(0, { line, 0 })
        return
      end
    end
  end
end

--- toggle inline diff preview for the current buffer
M.preview = function()
  local bufinfo = bufinfo_for_current_buf()
  if bufinfo == nil then return end
  if #bufinfo.hunks == 0 then vim.print("no changes to preview"); return end
  change.toggle(bufinfo)
end

--- reset the hunk under the cursor to its original content
M.reset_hunk = function()
  local bufinfo = bufinfo_for_current_buf()
  if bufinfo == nil then return end
  if #bufinfo.hunks == 0 then return end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  for _, hunk in ipairs(bufinfo.hunks) do
    local start_line = hunk[3]
    local count = hunk[4]
    -- top-of-file deletion has hunk[3] == 0 but sign is at line 1
    local cursor_line = (count == 0 and start_line == 0) and 1 or start_line
    if (count == 0 and row == cursor_line) or (count > 0 and row >= cursor_line and row <= cursor_line + count - 1) then
      local orig_start = hunk[1] - 1
      local orig_end = orig_start + hunk[2]
      local orig_lines = vim.api.nvim_buf_get_lines(bufinfo.prev_rev, orig_start, orig_end, false)
      if count == 0 then
        vim.api.nvim_buf_set_lines(bufinfo.buf, start_line, start_line, false, orig_lines)
      else
        vim.api.nvim_buf_set_lines(bufinfo.buf, start_line - 1, start_line + count - 1, false, orig_lines)
      end
      return
    end
  end
end

return M
