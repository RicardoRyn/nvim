-- Rainbow indent: draw colored indent guides for every visible nesting level.
-- mini.indentscope handles scope textobjects/motions; this module handles visuals.

local M = {}

local ns = vim.api.nvim_create_namespace("rainbow_indent")
local augroup = vim.api.nvim_create_augroup("SetupRainbowIndent", { clear = true })

local drawn = {} -- bufnr -> { first, last, levels = { [lnum] = level } }

-- Reuse existing highlight groups for indent levels. Override via setup({ hl = {...} }).
local hl_groups = {
  "DiagnosticError", -- red
  "String", -- green
  "Function", -- blue
  "Special", -- pink
  "Constant", -- orange
  "Statement", -- purple
  "Type", -- yellow
}

local function clear_buf(buf)
  pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)
  drawn[buf] = nil
end

function M.draw()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].rainbow_indent_disable then
    clear_buf(buf)
    return
  end
  if vim.b[buf].miniindentscope_disable then
    clear_buf(buf)
    return
  end

  local win = vim.api.nvim_get_current_win()
  local first = math.max(1, vim.fn.line("w0"))
  local last = vim.fn.line("w$")
  local sw = math.max(1, vim.bo[buf].shiftwidth)
  if sw == 0 then sw = math.max(1, vim.bo[buf].tabstop) end
  local ts = math.max(1, vim.bo[buf].tabstop)

  local prev = drawn[buf]
  if prev and prev.first == first and prev.last == last and prev.levels then
    local same = true
    for ln = first, last do
      local line = vim.api.nvim_buf_get_lines(buf, ln - 1, ln, false)[1] or ""
      local s = 0
      for ch in line:gmatch(".") do
        if ch == " " then s = s + 1 elseif ch == "\t" then s = s + ts else break end
      end
      local lv = math.floor(s / sw)
      if (prev.levels[ln] or 0) ~= lv then same = false break end
    end
    if same then return end
  end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local levels = {}
  for ln = first, last do
    local line = vim.api.nvim_buf_get_lines(buf, ln - 1, ln, false)[1] or ""
    if #line == 0 then
      levels[ln] = 0
    else
      local spaces = 0
      for ch in line:gmatch(".") do
        if ch == " " then spaces = spaces + 1
        elseif ch == "\t" then spaces = spaces + ts
        else break end
      end
      levels[ln] = math.floor(spaces / sw)
    end
  end

  for ln = first, last do
    local level = levels[ln]
    if level > 0 then
      local line = vim.api.nvim_buf_get_lines(buf, ln - 1, ln, false)[1] or ""
      if #line > 0 then
        local segments = {}
        for i = 1, level do
          local hl = hl_groups[((i - 1) % #hl_groups) + 1]
          if i > 1 then
            segments[#segments + 1] = { string.rep(" ", sw - 1), "NonText" }
          end
          segments[#segments + 1] = { "▏", hl }
        end
        pcall(vim.api.nvim_buf_set_extmark, buf, ns, ln - 1, 0, {
          virt_text = segments,
          virt_text_pos = "overlay",
          priority = 1,
          right_gravity = false,
        })
      end
    end
  end

  drawn[buf] = { first = first, last = last, levels = levels }
end

local function attach(buf)
  vim.api.nvim_create_autocmd(
    { "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "WinScrolled", "BufWinEnter" },
    {
      group = augroup,
      buffer = buf,
      callback = function()
        if vim.api.nvim_buf_is_valid(buf) then M.draw() end
      end,
    }
  )
  vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
    group = augroup,
    buffer = buf,
    callback = function()
      drawn[buf] = nil
    end,
  })
  vim.schedule(M.draw)
end

function M.setup(opts)
  opts = opts or {}
  if opts.hl then
    for i, h in ipairs(opts.hl) do hl_groups[i] = h end
  end
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "*",
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local skip = { "TelescopePrompt", "NvimTree", "neo-tree", "Outline", "qf", "help", "dashboard" }
      for _, x in ipairs(skip) do if ft == x then return end end
      attach(args.buf)
    end,
  })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then attach(buf) end
  end
end

function M.disable(buf)
  vim.b[buf or 0].rainbow_indent_disable = true
  clear_buf(buf or vim.api.nvim_get_current_buf())
end

function M.enable(buf)
  vim.b[buf or 0].rainbow_indent_disable = nil
  M.draw()
end

return M
