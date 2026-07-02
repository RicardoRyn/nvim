-- NOTE: All calls to jj are passed --ignore-working-copy
-- The working copy is never updated

local M = {}

--- vim system command opts
--- Run a jj command
--- @param args string[]
--- @param opts table?
--- @return string[]? stdout, string? stderr, integer? code
local jjrun = function(args, opts)
  opts = opts or {}
  local cmd = { "jj", "--ignore-working-copy", "--no-pager", "--color=never" }
  vim.list_extend(cmd, args)
  local result = vim.system(cmd, { cwd = opts.cwd, text = true }):wait()
  if result.code == 0 then
    local out = vim.split(result.stdout or "", "\n")
    return out, nil, 0
  else
    return nil, result.stderr, result.code
  end
end

--- Repository root for a given file
--- @param file string
--- @return string?
M.root_folder = function(file)
  local path = vim.fs.dirname(file)
  local out, _, code = jjrun({ "root" }, { cwd = path })
  if code == 0 and out and out[1] then
    return out[1]
  else
    return nil
  end
end

--- return the commit_id of the previous version
--- @param root string
--- @return string
M.previous_commit_id = function(root)
  local out, _, code = jjrun({ "log", "--no-graph", "-r", "@-", "-T", "commit_id.short()" }, { cwd = root })
  if code == 0 and out and #out > 0 then
    return out[1]
  end
  return "unknown"
end

--- return a buffer containing the previous version of the given file
--- The file name is assumed to be relative to the given repo root
--- @param file string
--- @param root string
--- @return integer?
M.previous_version = function(file, root)
  local out, _, code = jjrun({ "file", "show", string.format("'%s'", file), "-r", "@-" }, { cwd = root })
  local buf = vim.api.nvim_create_buf(false, false)
  if code == 0 and out then
    -- remove the empty line at the end if present
    if #out > 0 and out[#out] == "" then
      table.remove(out)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    vim.api.nvim_set_option_value("readonly", true, { buf = buf })
    vim.api.nvim_set_option_value("modified", false, { buf = buf })
    return buf
  end
  return nil
end

return M
