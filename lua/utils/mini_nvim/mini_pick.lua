local M = {}

M.preview = (function()
  local config = { orientation = "vertical", ratio = 0.6 }
  local state = { win_id = nil, buf_id = nil, last_item = nil, is_hidden = false }
  local cache = { win_config = {} }
  local scroll_map = { up = "<C-b>", down = "<C-f>", left = "zH", right = "zL" }

  local function reset()
    state.win_id = nil
    state.buf_id = nil
    state.last_item = nil
    state.is_hidden = false
    cache.win_config = {}
  end

  local function has_win() return state.win_id ~= nil and vim.api.nvim_win_is_valid(state.win_id) end

  local function create_buf()
    state.buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(state.buf_id, "minipick://" .. state.buf_id .. "/preview")
    vim.bo[state.buf_id].bufhidden = "wipe"
    vim.bo[state.buf_id].matchpairs = ""
    vim.b[state.buf_id].minicursorword_disable = true
    vim.b[state.buf_id].miniindentscope_disable = true
  end

  local function create_win(win_config)
    win_config.style = "minimal"
    state.win_id = vim.api.nvim_open_win(state.buf_id, false, win_config)
    vim.wo[state.win_id].foldenable = false
    vim.wo[state.win_id].foldmethod = "manual"
    vim.wo[state.win_id].linebreak = true
    vim.wo[state.win_id].scrolloff = 0
    vim.wo[state.win_id].winhighlight = "NormalFloat:MiniPickNormal,FloatBorder:MiniPickBorder"
    vim.wo[state.win_id].wrap = true
  end

  local function close_buf()
    pcall(vim.api.nvim_buf_delete, state.buf_id, { force = true })
    state.buf_id = nil
  end

  local function close_win()
    if has_win() then
      pcall(vim.api.nvim_win_close, state.win_id, true)
    end
    state.win_id = nil
  end

  local function close()
    close_win()
    close_buf()
    state.last_item = nil
  end

  ---@param item table | nil
  local function show_preview(item)
    if item ~= nil then
      local preview_func = MiniPick.get_picker_opts().source.preview
      pcall(preview_func, state.buf_id, item)
    else
      vim.api.nvim_buf_set_lines(state.buf_id, 0, -1, false, {})
    end
  end

  local function compute_border_size(border)
    local n = type(border) == "table" and #border or 0
    if n == 0 then
      return 2
    elseif config.orientation == "vertical" then
      return ((border[3 % n + 1] == "" and 0 or 1) + (border[7 % n + 1] == "" and 0 or 1))
    else
      return ((border[1 % n + 1] == "" and 0 or 1) + (border[5 % n + 1] == "" and 0 or 1))
    end
  end

  local function compute_layout(window_config, preview_config)
    local preview_ratio = config.ratio
    local border_size = compute_border_size(window_config.border)
    if window_config.width > 75 then -- horizontal preview when window is 75 columns or less
      local preview_width = math.floor(preview_ratio * window_config.width)
      local picker_width = window_config.width - preview_width - border_size
      window_config.width = picker_width
      preview_config.width = preview_width
      preview_config.col = window_config.col + picker_width + border_size
    else
      local preview_height = math.floor(preview_ratio * window_config.height)
      local picker_height = window_config.height - preview_height
      preview_config.height = preview_height
      window_config.height = picker_height
      preview_config.row = window_config.row - picker_height - border_size
    end
  end


  local function setup(opts) config = vim.tbl_deep_extend("force", config, opts or {}) end

  local function scroll(direction)
    if not has_win() then
      return
    end
    local keys = vim.api.nvim_replace_termcodes(scroll_map[direction], true, true, true)
    vim.api.nvim_win_call(state.win_id, function() vim.cmd("normal! " .. keys) end)
  end

  local function cache_win_config()
    local picker_state = MiniPick.get_picker_state()
    if not (picker_state.windows and picker_state.windows.main) then
      return
    end
    local window_config = vim.api.nvim_win_get_config(picker_state.windows.main)
    local keys = { "anchor", "border", "col", "height", "relative", "row", "width", "zindex" }
    for _, key in ipairs(keys) do
      cache.win_config[key] = window_config[key]
    end
  end

  local function update()
    vim.schedule(vim.cmd.redraw)
    if state.is_hidden then
      close()
      return
    end

    local picker_state = MiniPick.get_picker_state()
    if not (picker_state.windows and picker_state.windows.main) then
      return
    end

    local window_config = vim.deepcopy(cache.win_config)
    local preview_config = vim.deepcopy(cache.win_config)
    compute_layout(window_config, preview_config)

    vim.api.nvim_win_set_config(picker_state.windows.main, window_config)

    if not has_win() then
      create_buf()
      create_win(preview_config)
    else
      vim.api.nvim_win_set_config(state.win_id, preview_config)
    end

    local current_item = MiniPick.get_picker_matches().current
    if current_item ~= state.last_item then
      state.last_item = current_item
      create_buf()
      vim.api.nvim_win_set_buf(state.win_id, state.buf_id)
      show_preview(current_item)
    end
  end

  local function toggle()
    MiniPick.refresh()
    state.is_hidden = not state.is_hidden
    update()
  end

  local function stop()
    close()
    reset()
  end

  -- Update preview on picker refresh
  local mini_pick = require("mini.pick")
  local mini_pick_refresh = mini_pick.refresh
  mini_pick.refresh = function()
    mini_pick_refresh()
    if mini_pick.is_picker_active() then
      cache_win_config()
      vim.schedule(update)
    end
  end

  return {
    setup = setup,
    scroll = scroll,
    cache_win_config = cache_win_config,
    update = update,
    toggle = toggle,
    stop = stop,
  }
end)()

local group = vim.api.nvim_create_augroup("SetupMiniPick", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStart",
  group = group,
  callback = function()
    M.preview.cache_win_config()
    M.preview.update()
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickMatch",
  group = group,
  callback = function() vim.schedule(M.preview.update) end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStop",
  group = group,
  callback = M.preview.stop,
})

---@param keys string
function M.feedkeys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_input(keys)
end

--- Project-wide grep for TODO-like keywords, rendered with a colored keyword
--- prefix (like `MiniExtra.pickers.hipatterns`) on top of `MiniPick.builtin.grep`.
---
--- Notes:
--- - `item.text` is intentionally NOT mutated, so the default preview/choose
---   (which parses the `path\0lnum\0col\0text` format) keeps working.
--- - Highlight group per keyword is `MiniHipatterns<Keyword>` (PascalCase).
---@param keywords string[] Uppercase keywords, e.g. { "FIX", "TODO" }.
---@param opts table|nil Forwarded to `MiniPick.builtin.grep` as its `opts`.
function M.grep_todo(keywords, opts)
  if type(keywords) ~= "table" or #keywords == 0 then
    error("grep_todo: `keywords` must be a non-empty array")
  end

  local kw_set = {}
  for _, kw in ipairs(keywords) do
    kw_set[kw:upper()] = true
  end

  local hl_map = {}
  for kw in pairs(kw_set) do
    hl_map[kw] = "MiniHipatterns" .. kw:sub(1, 1) .. kw:sub(2):lower()
  end

  local find_keyword = function(text)
    local upper = text:upper()
    local first_kw, first_pos = nil, math.huge
    for kw in pairs(kw_set) do
      -- Require `KW:` exactly: leading word-boundary (`%f[%w]`) so partial
      -- matches like `PREFIX:` / `MYTODO:` are excluded, and a literal `:`
      -- right after the keyword so bare `FIX` / `TODO` are excluded.
      local pat = "%f[%w]" .. kw .. ":"
      local s = upper:find(pat)
      if s and s < first_pos then
        first_pos = s
        first_kw = kw
      end
    end
    return first_kw
  end

  -- Parse a single rg output line into {text, path, lnum, col, keyword}.
  -- Tries the null-byte format first (`path\0lnum\0col\0text`), then falls
  -- back to the colon-separated format (`path:lnum:col:text`) which is what
  -- some Windows builds of rg emit when `--field-match-separator \x00`
  -- doesn't take effect.
  local function parse_line(line)
    if type(line) ~= "string" or line == "" then return nil end

    local path, lnum_s, col_s, text
    if line:find("%z") then
      path, lnum_s, col_s, text = line:match("^([^%z]+)%z([^%z]+)%z([^%z]+)%z(.*)$")
    end
    if not path then
      -- Fallback: `path:lnum:col:text`. Avoid matching Windows drive letters
      -- like `C:/...` by anchoring the numeric part explicitly.
      path, lnum_s, col_s, text = line:match("^([^:]+):(%d+):(%d+):(.*)$")
    end
    if not path then return nil end

    return {
      text = line,
      path = path,
      lnum = tonumber(lnum_s),
      col = tonumber(col_s),
      keyword = find_keyword(text or ""),
    }
  end

  -- Normalize whatever item shape the picker hands us into our canonical table.
  local function normalize(item)
    if type(item) == "table" and type(item.text) == "string" then
      if item.path then return item end
      -- Table without `path`: try to (re)parse the raw text line.
      local parsed = parse_line(item.text)
      return parsed or item
    end
    if type(item) == "string" then
      return parse_line(item) or { text = item, path = "", lnum = 0, col = 0 }
    end
    return { text = tostring(item or ""), path = "", lnum = 0, col = 0 }
  end

  local postprocess = function(lines)
    local items = {}
    for i = 1, #(lines or {}) do
      local parsed = parse_line(lines[i])
      if parsed then items[#items + 1] = parsed end
    end
    return items
  end

  local ns_id = vim.api.nvim_create_namespace("mini-pick-grep-todo")
  local show = function(buf_id, items, query)
    if type(items) ~= "table" then items = {} end

    -- Normalize every incoming item into our canonical table shape.
    local norm = {}
    for i = 1, #items do
      norm[i] = normalize(items[i])
    end

    -- Compute prefix width (number of display cells) for keyword alignment.
    local prefix_width = 0
    for i = 1, #norm do
      local item = norm[i]
      if type(item.keyword) == "string" and item.keyword ~= "" then
        local ok, w = pcall(vim.fn.strchars, item.keyword)
        if ok and w and w > prefix_width then prefix_width = w end
      end
    end

    -- Build lines: "KEYWORD<pad> | <text>" where <text> is the raw rg line
    -- with any null bytes replaced by a visible pipe. Always emit one line
    -- per item so the picker's line index stays in sync with `items`.
    local tab = string.rep(" ", vim.o.tabstop > 0 and vim.o.tabstop or 4)
    local lines = {}
    for i = 1, #norm do
      local item = norm[i]
      local raw = type(item.text) == "string" and item.text or ""
      if raw == "" then
        lines[i] = ""
      else
        local text = raw:gsub("%z", "│"):gsub("[\r\n]+", " "):gsub("\t", tab)
        local kw = type(item.keyword) == "string" and item.keyword or ""
        local ok, kw_w = pcall(vim.fn.strchars, kw)
        if not ok or not kw_w then kw_w = #kw end
        local pad = prefix_width > kw_w and string.rep(" ", prefix_width - kw_w) or ""
        if prefix_width > 0 then
          lines[i] = (kw .. pad) .. " │ " .. text
        else
          lines[i] = text
        end
      end
    end

    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

    -- Apply keyword highlight only where we actually have a keyword.
    vim.api.nvim_buf_clear_namespace(buf_id, ns_id, 0, -1)
    for i = 1, #norm do
      local item = norm[i]
      local kw = type(item.keyword) == "string" and item.keyword or nil
      if kw and kw ~= "" and hl_map[kw] then
        pcall(vim.api.nvim_buf_set_extmark, buf_id, ns_id, i - 1, 0, {
          end_row = i - 1,
          end_col = #kw + 1,
          hl_group = hl_map[kw],
          priority = 200,
        })
      end
    end
  end

  local pattern = "\\b(" .. table.concat(keywords, "|") .. "):"
  local final_opts = vim.tbl_deep_extend("force", { source = { show = show } }, opts or {})
  MiniPick.builtin.grep({ pattern = pattern, postprocess = postprocess }, final_opts)
end

local icon_cache
local icon_ns_id

--- Open a `MiniPick` picker over all `MiniIcons` entries. Choosing an item
--- inserts its glyph at the cursor position of the window that was current
--- when the picker was opened.
function M.pick_icons()
  if not icon_cache then
    icon_cache = {}
    for _, cat in ipairs({ "directory", "extension", "file", "filetype", "lsp", "os" }) do
      for _, name in ipairs(MiniIcons.list(cat)) do
        local glyph, hl = MiniIcons.get(cat, name)
        table.insert(icon_cache, {
          glyph = glyph,
          text = glyph .. "  " .. name .. "  [" .. cat .. "]",
          hl = hl,
          category = cat,
        })
      end
    end
  end

  if not icon_ns_id then
    icon_ns_id = vim.api.nvim_create_namespace("mini-pick-icons")
  end

  local show = function(buf_id, items, query)
    local lines = {}
    for i, item in ipairs(items) do
      lines[i] = item.text
    end
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    vim.api.nvim_buf_clear_namespace(buf_id, icon_ns_id, 0, -1)
    for i, item in ipairs(items) do
      vim.api.nvim_buf_set_extmark(buf_id, icon_ns_id, i - 1, 0, {
        end_col = #item.glyph,
        hl_group = item.hl,
        priority = 200,
      })
    end
    return icon_ns_id
  end

  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  local choose = function(item)
    MiniPick.stop()
    local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
    local new_line = line:sub(1, col) .. item.glyph .. line:sub(col + 1)
    vim.api.nvim_buf_set_lines(buf, row - 1, row, false, { new_line })
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == buf then
        vim.api.nvim_win_set_cursor(win, { row, col + #item.glyph })
        break
      end
    end
  end

  MiniPick.start({
    source = {
      items = icon_cache,
      name = "Icons",
      show = show,
      choose = choose,
    },
  })
end

local function lsp_preview(buf_id, item)
  local lines = {}
  local add = function(s) lines[#lines + 1] = s end
  local add_sep = function() add(string.rep("─", 50)) end

  local scope = item and item.scope
  if scope == "client" or scope == "info" then
    local c = item.client
    add("Name:              " .. c.name)
    add("ID:                " .. tostring(c.id))
    add("Root Dir:          " .. (c.root_dir or "(none)"))
    add("Cmd:               " .. (type(c.config.cmd) == "table" and table.concat(c.config.cmd, " ") or tostring(c.config.cmd or "(none)")))
    add("Offset Encoding:   " .. (c.offset_encoding or "utf-16"))
    local bufs = vim.tbl_keys(c.attached_buffers or {})
    add("Attached Buffers:  " .. #bufs)
    if c.initialized ~= nil then
      add("Initialized:       " .. tostring(c.initialized))
    end
    if c.workspace_folders then
      add("Workspace Folders:")
      for _, wf in ipairs(c.workspace_folders) do
        add("  - " .. (wf.name or "") .. "  " .. (wf.uri or ""))
      end
    end
  elseif scope == "buffers" then
    local c = item.client
    for bufnr in pairs(c.attached_buffers or {}) do
      local name = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) or "(invalid)"
      local ft = vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype or "?"
      add(string.format("[%d] %s  (%s)", bufnr, name ~= "" and name or "(unnamed)", ft))
    end
    if #lines == 0 then add("(no attached buffers)") end
  elseif scope == "capabilities" then
    local c = item.client
    local caps = c.server_capabilities or {}
    local sorted = vim.tbl_keys(caps)
    table.sort(sorted)
    for _, key in ipairs(sorted) do
      local val = caps[key]
      local status = (val == false) and "✗" or "✓"
      if type(val) == "table" and not vim.tbl_isempty(val) then
        local s = vim.inspect(val, { indent = "  ", newline = "\n", depth = 2 })
        add(status .. " " .. key .. ": " .. s:gsub("\n", "\n    "))
      else
        add(status .. " " .. key)
      end
    end
    if #lines == 0 then add("(no capabilities)") end
  elseif scope == "config" then
    local c = item.client
    local cfg = c.config or {}
    for _, key in ipairs({ "cmd", "handlers", "init_options", "settings" }) do
      if cfg[key] ~= nil then
        add(key .. ":")
        add_sep()
        local s = vim.inspect(cfg[key], { indent = "  ", newline = "\n", depth = 4 })
        for line in s:gmatch("[^\n]+") do add("  " .. line) end
        add("")
      end
    end
    if #lines == 0 then add("(no config)") end
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
end

local function lsp_choose_client(client_item)
  local client = client_item.client
  local items = {
    { text = "Overview              " .. client.name .. " (id=" .. client.id .. ")", scope = "info", client = client },
    { text = "Attached Buffers      " .. #vim.tbl_keys(client.attached_buffers or {}), scope = "buffers", client = client },
    { text = "Server Capabilities   " .. #vim.tbl_keys(client.server_capabilities or {}), scope = "capabilities", client = client },
    { text = "Client Config", scope = "config", client = client },
  }
  MiniPick.start({
    source = {
      items = items,
      name = "LSP: " .. client.name,
      preview = lsp_preview,
      choose = function() end,
    },
  })
end

function M.pick_lsp_info()
  local clients = vim.lsp.get_clients()
  if not clients or vim.tbl_isempty(clients) then
    vim.notify("No LSP clients running", vim.log.levels.INFO)
    return
  end
  local items = {}
  for _, c in ipairs(clients) do
    local bufs = vim.tbl_keys(c.attached_buffers or {})
    items[#items + 1] = {
      text = c.name .. "  (id=" .. c.id .. ", buffers=" .. #bufs .. ")  " .. (c.root_dir or ""),
      client = c,
      scope = "client",
    }
  end
  MiniPick.start({
    source = {
      items = items,
      name = "LSP Clients",
      preview = lsp_preview,
      choose = lsp_choose_client,
    },
  })
end

return M
