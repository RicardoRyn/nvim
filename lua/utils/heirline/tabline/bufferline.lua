-- TODO: 指定次数执行bufferline移动

local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")
local FileIcon = require("utils.heirline.statusline.file_others").get_fileicon()

local TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ". "
  end,
  hl = function()
    return { fg = utils.get_highlight("Comment").fg }
  end,
}

local TablineFileName = {
  provider = function(self)
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return " " .. filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

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
  TablineBufnr,
  FileIcon,
  TablineFileName,
  TablineFileFlags,
}

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

local TablineBufferBlock = utils.surround({ "", "" }, function(self)
  if self.is_active then
    return utils.get_highlight("TabLineSel").bg
  else
    return utils.get_highlight("TabLine").bg
  end
end, { TablineFileNameBlock, TablineCloseButton })

local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

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

  if vim.bo.filetype == "snacks_dashboard" then
    vim.o.showtabline = 1
  else
    vim.o.showtabline = 2
  end

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

-- 模块加载时主动延迟重建，覆盖 SessionLoadPost 等事件在模块加载前已触发的情况
vim.schedule(function()
  rebuild_buflist_cache()
end)

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
