local M = {}

local config_mod = require("utils.csv_view.config")
local sniffer = require("utils.csv_view.sniffer")
local parser = require("utils.csv_view.parser")
local renderer = require("utils.csv_view.renderer")
local jump = require("utils.csv_view.jump")
local sticky_header = require("utils.csv_view.sticky_header")

local buffer_states = {}
local config = config_mod.defaults

function M.get_state(bufnr)
  return buffer_states[bufnr or vim.api.nvim_get_current_buf()]
end

-----------------------------------------------------------------------------
-- 大文件判定（与 snacks.bigfile 相同的公式）
-----------------------------------------------------------------------------
local function is_big_file(bufnr)
  local opts = config.big_file
  if Snacks and Snacks.config then
    local ok, snacks_opts = pcall(Snacks.config.get, "bigfile", {})
    if ok and type(snacks_opts) == "table" then
      opts = vim.tbl_extend("force", opts, {
        size = snacks_opts.size or opts.size,
        line_length = snacks_opts.line_length or opts.line_length,
      })
    end
  end
  local path = vim.api.nvim_buf_get_name(bufnr)
  local size = path ~= "" and vim.fn.getfsize(path) or -1
  if size > opts.size then return true end
  if size <= 0 then return false end
  local lines = vim.api.nvim_buf_line_count(bufnr)
  return lines > 0 and (size - lines) / lines > opts.line_length
end

-----------------------------------------------------------------------------
-- 窗口设置
-----------------------------------------------------------------------------
local function setup_window(winid, enable)
  if enable then
    vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local", win = winid })
    vim.api.nvim_set_option_value("concealcursor", "nvic", { scope = "local", win = winid })
    vim.api.nvim_set_option_value("wrap", false, { scope = "local", win = winid })
  else
    vim.api.nvim_set_option_value("conceallevel", 0, { scope = "local", win = winid })
    vim.api.nvim_set_option_value("concealcursor", "", { scope = "local", win = winid })
  end
end

-----------------------------------------------------------------------------
-- enable / disable
-----------------------------------------------------------------------------
function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if buffer_states[bufnr] and buffer_states[bufnr].enabled then return end

  renderer.define_highlights()

  local delim, _ = sniffer.resolve_delimiter(bufnr, config)
  local quote_char = config.parser.quote_char
  local big_mode = is_big_file(bufnr)
  local metrics
  if big_mode then
    metrics = parser.compute_metrics_sampled(bufnr, delim, quote_char, config.big_file.sample_lines)
  else
    metrics = parser.compute_metrics(bufnr, delim, quote_char)
  end

  local state = {
    enabled = true,
    big_mode = big_mode,
    extmarks = {},
    rendered = {},
    metrics = metrics,
    delimiter = delim,
    quote_char = quote_char,
  }
  buffer_states[bufnr] = state

  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    setup_window(winid, true)
  end

  vim.keymap.set({ "n", "i" }, "<Tab>", jump.goto_next_field, { buffer = bufnr, desc = "Go to next CSV field" })
  vim.keymap.set({ "n", "i" }, "<S-Tab>", jump.goto_prev_field, { buffer = bufnr, desc = "Go to previous CSV field" })

  renderer.render_visible(state, bufnr, metrics, config)
  sticky_header.redraw(bufnr, config)
end

function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local state = buffer_states[bufnr]
  if not state or not state.enabled then return end

  renderer.clear_rendering(bufnr, state)

  pcall(vim.keymap.del, { "n", "i" }, "<Tab>", { buffer = bufnr })
  pcall(vim.keymap.del, { "n", "i" }, "<S-Tab>", { buffer = bufnr })

  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    setup_window(winid, false)
    sticky_header.close_header_win_for(winid)
  end

  state.enabled = false
  state.metrics = nil
end

function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if buffer_states[bufnr] and buffer_states[bufnr].enabled then
    M.disable(bufnr)
  else
    M.enable(bufnr)
  end
end

function M.setup(opts)
  config = config_mod.merge(opts)
  M.enable()
end

-----------------------------------------------------------------------------
-- 自动命令
-----------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("SetupCsvView", { clear = true })

--- 注册 FileType bigfile 触发（需在启动时调用，snacks 把大 CSV 的 ft 改成了 bigfile，
--- csv ftplugin 不会执行）。schedule 保证启用落在 snacks.bigfile 的 setup 之后，
--- 以便覆盖其 conceallevel=0 / statuscolumn=""。
function M.register_bigfile_autocmd()
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "bigfile",
    callback = function(args)
      local bufnr = args.buf
      if vim.bo[bufnr].buftype ~= "" then return end
      local ft = vim.filetype.match({ buf = bufnr })
      if ft ~= "csv" and ft ~= "tsv" then return end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          M.enable(bufnr)
        end
      end)
    end,
  })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local state = buffer_states[bufnr]
    if state and state.enabled and state.metrics then
      renderer.render_visible(state, bufnr, state.metrics, config)
      sticky_header.redraw(bufnr, config)
    end
  end,
})

vim.api.nvim_create_autocmd("WinScrolled", {
  group = augroup,
  callback = function(args)
    local winid = args.win
    if not winid then return end
    local ok, bufnr = pcall(vim.api.nvim_win_get_buf, winid)
    if not ok then return end
    local state = buffer_states[bufnr]
    if state and state.enabled and state.metrics then
      renderer.render_visible(state, bufnr, state.metrics, config)
      sticky_header.redraw(bufnr, config)
    end
  end,
})

vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
  group = augroup,
  callback = function()
    for bufnr, state in pairs(buffer_states) do
      if state.enabled then
        sticky_header.redraw(bufnr, config)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local state = buffer_states[bufnr]
    if state and state.enabled then
      sticky_header.close_header_win_for(vim.api.nvim_get_current_win())
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  group = augroup,
  callback = function(args)
    sticky_header.close_header_win_for(tonumber(args.match))
  end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local state = buffer_states[bufnr]
    if state and state.enabled then
      renderer.clear_rendering(bufnr, state)
      if state.big_mode then
        state.metrics.rows = {}
      else
        state.metrics = parser.compute_metrics(bufnr, state.delimiter, state.quote_char)
      end
      renderer.render_visible(state, bufnr, state.metrics, config)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
  group = augroup,
  callback = function(args)
    buffer_states[args.buf] = nil
  end,
})

-----------------------------------------------------------------------------
-- 用户命令
-----------------------------------------------------------------------------
vim.api.nvim_create_user_command("CsvViewToggle", function()
  M.toggle()
end, { desc = "Toggle CSV table view for current buffer" })

return M
