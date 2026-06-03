-- FIX: 不同buffer具有相同图标
-- TODO: 指定次数执行bufferline移动

local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")
local FileIcon = require("utils.heirline.statusline.file_others").FileIcon

local TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ". "
  end,
  hl = function()
    return { fg = utils.get_highlight("Comment").fg }
  end,
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return " " .. filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
local TablineFileFlags = {
  {
    condition = function(self)
      return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
    end,
    provider = "  ",
    hl = function()
      return { fg = colors.green, bold = true }
    end,
  },
  {
    condition = function(self)
      return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
    end,
    provider = function(self)
      if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
        return "  "
      else
        return " "
      end
    end,
    hl = function()
      return { fg = colors.orange, bold = true }
    end,
  },
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return { fg = utils.get_highlight("TabLineSel").fg }
    else
      return { fg = utils.get_highlight("TabLine").fg }
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then -- close on mouse middle click
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },
  -- TablineBufnr,
  FileIcon,
  TablineFileName,
  TablineFileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
  condition = function(self)
    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
  end,
  { provider = " " },
  {
    provider = "",
    hl = function()
      return { fg = utils.get_highlight("Comment").fg }
    end,
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

-- The final touch!
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
  if self.is_active then
    return utils.get_highlight("TabLineSel").bg
  else
    return utils.get_highlight("TabLine").bg
  end
end, { TablineBufnr, TablineFileNameBlock, TablineCloseButton })

-- this is the default function used to retrieve buffers
local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
local buflist_cache = {}

--- 从 buffer_move 模块获取 buffer 顺序，重建 buflist_cache
--- 若 buffer_move 未加载，回退到 Neovim 原生 buffer list
local function rebuild_buflist_cache()
  local buffers = {}

  -- 优先使用 buffer_move 维护的顺序
  local ok, bm = pcall(require, "utils.buffer_move")
  if ok then
    local order = bm.order()
    local seen = {}
    for _, buf in ipairs(order) do
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
        buffers[#buffers + 1] = buf
        seen[buf] = true
      end
    end
    -- 追加 buffer_move 尚未追踪到的 buffer（防止竞态）
    for _, buf in ipairs(get_bufs()) do
      if not seen[buf] then
        buffers[#buffers + 1] = buf
        seen[buf] = true
      end
    end
  else
    buffers = get_bufs()
  end

  for i, v in ipairs(buffers) do
    buflist_cache[i] = v
  end
  for i = #buffers + 1, #buflist_cache do
    buflist_cache[i] = nil
  end

  -- check how many buffers we have and set showtabline accordingly
  if #buflist_cache > 1 then
    vim.o.showtabline = 2 -- always
  elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
    vim.o.showtabline = 1 -- only when #tabpages > 1
  end

  -- 缓存已更新，重绘 tabline
  vim.cmd.redrawtabline()
end

-- setup autocmds that update the buflist_cache every time buffers are added/removed
local schedule_rebuild = function()
  vim.schedule(rebuild_buflist_cache)
end

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete", "BufEnter" }, {
  callback = schedule_rebuild,
})

-- 监听 buffer_move 模块发出的 buffer 顺序变更事件（同步执行，无延迟）
vim.api.nvim_create_autocmd("User", {
  pattern = "BufferMoveOrderChanged",
  callback = rebuild_buflist_cache,
})

-- session 恢复后，强制同步重建缓存（此时所有 buffer 已加载完毕）
vim.api.nvim_create_autocmd("SessionLoadPost", {
  callback = rebuild_buflist_cache,
})

-- 模块加载时主动延迟重建，覆盖 SessionLoadPost 等事件在模块加载前已触发的情况
-- （如 VeryLazy 加载的 heirline 在 session 恢复后才初始化）
vim.schedule(function()
  rebuild_buflist_cache()
end)

-- and here we go
local M = utils.make_buflist(
  TablineBufferBlock,
  {
    provider = "",
    hl = function()
      return { fg = utils.get_highlight("Comment").fg }
    end,
  },
  {
    provider = "",
    hl = function()
      return { fg = utils.get_highlight("Comment").fg }
    end,
  },
  -- out buf_func simply returns the buflist_cache
  function()
    return buflist_cache
  end,
  -- no cache, as we're handling everything ourselves
  false
)

return M
