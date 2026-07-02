vim.o.showtabline = 2
local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")
local FileIcon = require("utils.heirline.statusline.file_others").get_fileicon()

local TablineBufnr = {
  provider = function(self)
    local ok, _ = pcall(require, "utils.buffer_actions")
    if ok and require("utils.buffer_actions.state").state.is_picking then
      return " " .. require("utils.buffer_actions.state").state.pick_labels[self.bufnr] .. ". "
    else
      return " " .. tostring(self.bufnr) .. ". "
    end
  end,
  hl = function()
    local ok, _ = pcall(require, "utils.buffer_actions")
    if ok and require("utils.buffer_actions.state").state.is_picking then
      return { fg = colors.red, bold = true }
    else
      return { fg = utils.get_highlight("Comment").fg }
    end
  end,
}

-- pin marker shown before the filename for pinned buffers
local TablinePinMark = {
  provider = function(self)
    return require("utils.buffer_actions").is_pinned(self.bufnr) and "󰐃 " or ""
  end,
  hl = { fg = colors.red },
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true, underline = self.is_active }
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
    hl = { fg = "green" },
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
        return "  "
      end
    end,
    hl = { fg = "orange" },
  },
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return "TabLineSel"
      -- why not?
      -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
      --     return { fg = "gray" }
    else
      return "TabLine"
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
  TablinePinMark,
  FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
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
    provider = " ",
    hl = { fg = "gray" },
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
local TablineBufferBlock = utils.surround({ "", "" }, function(self)
  if self.is_active then
    return utils.get_highlight("TabLineSel").bg
  else
    return utils.get_highlight("TabLine").bg
  end
end, { TablineFileNameBlock, TablineCloseButton })

-- initialize the buflist cache
local bufferline_cache = {}

-- this is the default function used to retrieve buffers
local function get_bufs()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
  end, vim.api.nvim_list_bufs())
end

local function rebuild_bufferline_cache()
  local buffers = {}

  local ba = require("utils.buffer_actions")
  local buffer_order = ba.get_buffer_order()

  if next(buffer_order) == nil then
    -- when no session file，buffer_order is empty
    buffer_order = get_bufs()
  end

  for _, bufnr in ipairs(buffer_order) do
    buffers[#buffers + 1] = bufnr
  end

  for i, v in ipairs(buffers) do
    bufferline_cache[i] = v
  end
  for i = #buffers + 1, #bufferline_cache do
    bufferline_cache[i] = nil
  end

  vim.cmd.redrawtabline()
end

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
  callback = function()
    vim.schedule(function()
      local bufferline = get_bufs()
      for i, v in ipairs(bufferline) do
        bufferline_cache[i] = v
      end
      for i = #bufferline + 1, #bufferline_cache do
        bufferline_cache[i] = nil
      end
    end)
    -- update the bufferline_cache when first in nvim
    vim.schedule(function()
      rebuild_bufferline_cache()
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BufferOrderChanged",
  callback = function()
    rebuild_bufferline_cache()
  end,
})

local M = utils.make_buflist(
  TablineBufferBlock,
  { provider = "", hl = { fg = "gray" } },
  { provider = "", hl = { fg = "gray" } },
  function()
    return bufferline_cache
  end,
  false
)

return M
