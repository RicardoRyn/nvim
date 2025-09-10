local function augroup(name)
  return vim.api.nvim_create_augroup("ricardo_" .. name, { clear = true })
end

-- 再次打开文件，光标位于上次打开的地方
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
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

if not vim.g.vscode then
  -- automatically import output chunks from a jupyter notebook
  -- tries to find a kernel that matches the kernel in the jupyter notebook
  -- falls back to a kernel that matches the name of the active venv (if any)

  -- 定义 imb 函数：初始化 molten buffer
  local imb = function(e) -- init molten buffer
    vim.schedule(function()
      local kernels = vim.fn.MoltenAvailableKernels()
      local try_kernel_name = function()
        local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
        return metadata.kernelspec.name
      end
      local ok, kernel_name = pcall(try_kernel_name)
      if not ok or not vim.tbl_contains(kernels, kernel_name) then
        kernel_name = nil
        local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
        if venv ~= nil then
          kernel_name = string.match(venv, "/.+/(.+)")
        end
      end
      if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
        vim.cmd(("MoltenInit %s"):format(kernel_name))
      end
      vim.cmd("MoltenImportOutput")
    end)
  end
  -- 自动导入输出
  -- automatically import output chunks from a jupyter notebook
  vim.api.nvim_create_autocmd("BufAdd", {
    pattern = { "*.ipynb" },
    callback = imb,
  })
  -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.ipynb" },
    callback = function(e)
      if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
        imb(e)
      end
    end,
  })
  -- 自动导出输出
  -- automatically export output chunks to a jupyter notebook on write
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.ipynb" },
    callback = function()
      if require("molten.status").initialized() == "Molten" then
        vim.cmd("MoltenExportOutput!")
      end
    end,
  })

  -- 当你打开 .py 文件时，Molten 的虚拟行（virt_lines_off_by_1）和虚拟文本输出（virt_text_output）都会 关闭，避免 Python 代码文件里出现执行输出的虚拟行/文本（因为可能会干扰正常代码阅读）。
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function(e)
      if string.match(e.file, ".otter.") then
        return
      end
      if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
        vim.fn.MoltenUpdateOption("virt_text_output", false)
      else
        vim.g.molten_virt_lines_off_by_1 = false
        vim.g.molten_virt_text_output = false
      end
    end,
  })
  -- 当你返回 .qmd、.md、.ipynb 文件时，这两个选项会 开启，这样在文档里就能直接看到代码执行的输出（Molten 会用虚拟行和虚拟文本把结果插在代码下面）。
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.qmd", "*.md", "*.ipynb" },
    callback = function(e)
      if string.match(e.file, ".otter.") then
        return
      end
      if require("molten.status").initialized() == "Molten" then
        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
        vim.fn.MoltenUpdateOption("virt_text_output", true)
      else
        vim.g.molten_virt_lines_off_by_1 = true
        vim.g.molten_virt_text_output = true
      end
    end,
  })
end
