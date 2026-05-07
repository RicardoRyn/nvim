local function augroup(name)
  return vim.api.nvim_create_augroup("ricardo_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("check_workspace_jump"),
  callback = function(args)
    local buf = args.buf

    -- 1. 忽略非普通文件（例如终端、NvimTree、各种工具面板等）
    if vim.bo[buf].buftype ~= "" then
      return
    end

    -- 2. 忽略悬浮窗（极度重要：防止你在 Snacks 列表上下滚动预览时疯狂弹窗）
    local win = vim.api.nvim_get_current_win()
    local win_config = vim.api.nvim_win_get_config(win)
    if win_config.relative ~= "" then
      return
    end

    -- 3. 防止同一个文件来回切换时反复弹窗（每个文件只弹一次）
    if vim.b[buf].out_of_workspace_warned then
      return
    end

    local filepath = vim.api.nvim_buf_get_name(buf)
    if filepath == "" then
      return
    end

    -- 4. 规范化路径（统一斜杠，避免 Windows/Mac 差异）
    local cwd = vim.fs.normalize(vim.fn.getcwd())
    filepath = vim.fs.normalize(filepath)

    -- 保证 cwd 以 / 结尾，防止错误匹配（如 /project 匹配到 /project_test）
    if cwd:sub(-1) ~= "/" then
      cwd = cwd .. "/"
    end

    -- 5. 核心逻辑：如果当前文件路径不是以工作区路径开头，说明跳出去了！
    if not vim.startswith(filepath, cwd) then
      -- 触发 Snacks 弹窗
      Snacks.notify.warn(
        "Jump to:\n" .. filepath,
        { title = "Jump out of workspace" }
      )
      -- 标记该 buffer 已警告过
      vim.b[buf].out_of_workspace_warned = true
    end
  end,
})

-- 使用`o`和`O`时不会自动添加注释符号
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_o_comment"),
  pattern = { "lua", "python", "rust", "sh" },
  callback = function()
    vim.opt.formatoptions:remove({ "o" })
  end,
})

-- 再次打开文件，光标位于上次打开的地方
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].ricardo_last_loc then
      return
    end
    vim.b[buf].ricardo_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 通用q来退出部分页面
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "dap-float",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- 当打开手册文件时，避免其出现在buffer列表中
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("man_unlisted"),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- 禁用 JSON 文件中的“隐藏显示”（conceal）功能，确保内容完全可见
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- 在保存文件之前，自动创建文件所在的目录（如果目录不存在），从而避免保存失败。
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
