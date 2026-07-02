local conditions = require("heirline.conditions")
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
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = "(",
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("+" .. count)
    end,
    hl = { fg = "git_add" },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("-" .. count)
    end,
    hl = { fg = "git_del" },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("~" .. count)
    end,
    hl = { fg = "git_change" },
  },
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = ")",
  },
}

local M = {
  JjLog = JjLog,
  Diff = Diff,
}

return M
