local colors = require("utils.heirline.colors")
local jj_log = require("utils.jj_log")

vim.g.heirline_jjlog_bg = colors.blue

local git_branch_cache = {}

local function get_buf_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = (vim.uv or vim.loop).cwd()
  end
  return path
end

local function get_git_root()
  return vim.fs.root(get_buf_path(), ".git")
end

local function git_output(root, args)
  local command = { "git", "-C", root }
  vim.list_extend(command, args)

  local output = vim.fn.systemlist(command)
  if vim.v.shell_error ~= 0 or not output[1] then
    return nil
  end

  local result = vim.trim(output[1])
  return result ~= "" and result or nil
end

local function get_git_branch()
  local root = get_git_root()
  if not root then
    return nil
  end

  local now = (vim.uv or vim.loop).hrtime()
  local cached = git_branch_cache[root]
  if cached and now - cached.time < 2 * 1e9 then
    return cached.branch
  end

  local branch = git_output(root, { "branch", "--show-current" })
    or git_output(root, { "rev-parse", "--short", "HEAD" })

  git_branch_cache[root] = { branch = branch, time = now }
  return branch
end

local JjLog = {
  init = function(self)
    local color_info = jj_log.get_color()
    if color_info then
      self.hl_color = { fg = colors.background, bg = color_info.fg, bold = (color_info.gui == "bold") }
    else
      self.hl_color = { fg = colors.background, bg = colors.gray }
    end
    vim.g.heirline_jjlog_bg = self.hl_color.bg
  end,
  hl = function(self)
    return self.hl_color
  end,
  {
    condition = function()
      return jj_log.is_jj_repo()
    end,
    provider = function()
      return " " .. jj_log.get() .. " "
    end,
    update = {
      "User",
      pattern = "JJStatusUpdated",
      callback = vim.schedule_wrap(function()
        vim.cmd("redrawstatus")
      end),
    },
  },
  {
    condition = function(self)
      if jj_log.is_jj_repo() then
        return false
      end
      self.git_branch = get_git_branch()
      return self.git_branch ~= nil
    end,
    provider = function(self)
      return "  " .. self.git_branch
    end,
  },
}

local Diff = {
  condition = function()
    local diff = require("utils.diff_signs.buffers").diff()
    return diff ~= nil and diff.added ~= nil
  end,
  init = function(self)
    self.diff = require("utils.diff_signs.buffers").diff()
  end,
  {
    provider = function(self)
      return (self.diff.added > 0 or self.diff.deleted > 0 or self.diff.changed > 0) and " ("
    end,
  },
  {
    provider = function(self)
      return self.diff.added > 0 and ("+" .. self.diff.added) or ""
    end,
    hl = function()
      return { fg = colors.git_add }
    end,
  },
  {
    provider = function(self)
      return self.diff.deleted > 0 and ("-" .. self.diff.deleted) or ""
    end,
    hl = function()
      return { fg = colors.git_del }
    end,
  },
  {
    provider = function(self)
      return self.diff.changed > 0 and ("~" .. self.diff.changed) or ""
    end,
    hl = function()
      return { fg = colors.git_change }
    end,
  },
  {
    provider = function(self)
      return (self.diff.added > 0 or self.diff.deleted > 0 or self.diff.changed > 0) and ")"
    end,
  },
}

local M = {
  JjLog = JjLog,
  Diff = Diff,
}

return M
