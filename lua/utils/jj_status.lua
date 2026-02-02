local M = {}

-- 尝试在特殊模式下禁用此模块，以避免冲突
local function is_special_mode()
  for _, arg in ipairs(vim.v.argv) do
    if arg:match("DiffEditor") or arg:match("wincmd J") then
      return true
    end
  end
  return false
end

if is_special_mode() then
  M.get = function()
    return ""
  end
  M.get_color = function()
    return nil
  end
  return M
end

local jj_cmd = [[jj log --revisions @ --no-graph --color never --limit 1 --template '
  separate(" ",
    change_id.shortest(4),
    bookmarks,
    concat(
      if(conflict, "💥"),
      if(divergent, "🚧"),
      if(hidden, "👻"),
      if(immutable, "🔒"),
    ),
    if(
      empty,
      "󰱒",
      "󰏭"
    ),
    coalesce(
      truncate_end(29, description.first_line(), "…"),
      "󰄱 "
    )
  )
']]

local cached_status = ""
local is_exiting = false
local running_job_id = nil

local function update_status()
  -- 如果正在退出，不启动新的 jj 进程
  if is_exiting then
    return
  end

  local output = {}
  running_job_id = vim.fn.jobstart(jj_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, exit_code)
      running_job_id = nil
      if exit_code == 0 then
        local result = table.concat(output, "")
        cached_status = " " .. vim.trim(result)
      else
        cached_status = ""
      end
    end,
  })
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  callback = function()
    update_status()
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  -- 在退出前停止所有正在运行的 jj 进程，防止产生锁文件
  callback = function()
    is_exiting = true
    if running_job_id then
      vim.fn.jobstop(running_job_id)
      running_job_id = nil
    end
  end,
})

M.get = function()
  return cached_status
end

M.get_color = function()
  local flavour = require("catppuccin").flavour
  local colors = require("catppuccin.palettes").get_palette(flavour)
  if cached_status == "" then
    return nil
  end

  if cached_status:find("💥") or cached_status:find("🚧") or cached_status:find("🔒") then
    return { fg = colors.red, gui = "bold" }
  elseif string.find(cached_status, "󰱒") then
    return { fg = colors.green, gui = "bold" }
  else
    return { fg = colors.yellow, gui = "bold" }
  end
end

return M
