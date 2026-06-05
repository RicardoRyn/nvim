local utils = require("heirline.utils")
local colors = require("utils.heirline.colors")

local SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount)) .. " "
  end,
}

local MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
  end,
  provider = "  ",
  hl = function()
    return { fg = colors.purple, bold = true }
  end,
  utils.surround({ "[", "]" }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    -- hl = { fg = colors.green, bold = true },
  }),
  update = {
    "RecordingEnter",
    "RecordingLeave",
  },
}

-- FIX:
vim.opt.showcmdloc = "statusline"
local ShowCmd = {
  condition = function()
    return vim.o.cmdheight == 0
  end,
  provider = ":%3.5(%S%) ",
}

local SelectionCount = {
  condition = function()
    local mode = vim.fn.mode(1)
    return mode:find("^[vV\22]") ~= nil
  end,
  provider = function()
    local mode = vim.fn.mode(1)
    local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
    if mode:find("^V") then
      -- V 或 Vs 为可视行模式
      return string.format("[%dL]", lines) .. " "
    elseif mode:find("^\22") then
      -- <C-v> (\22) 为可视块模式
      local cols = math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1
      return string.format("[%dx%d]", lines, cols) .. " "
    else
      -- 普通可视模式 v
      local wc = vim.fn.wordcount()
      if wc.visual_chars then
        return string.format("[%dC]", wc.visual_chars) .. " "
      end
      -- 兜底计算
      return string.format("[%dC]", math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1) .. " "
    end
  end,
  hl = function()
    return { fg = colors.cyan, bold = true }
  end,
  update = { "ModeChanged", "CursorMoved" },
}

local M = {
  SearchCount = SearchCount,
  MacroRec = MacroRec,
  ShowCmd = ShowCmd,
  SelectionCount = SelectionCount,
}

return M
