-- CSV 视图的启动期入口：只注册触发点，任何重活（parser / renderer / sticky header）
-- 都推迟到真正命中时才 require，避免每次启动都加载整套模块。
local M = {}

local function is_csv_like(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local ft = vim.filetype.match({ buf = bufnr })
  return ft == "csv" or ft == "tsv"
end

--- 注册启动期需要的全部触发点。
--- 注意：snacks.bigfile 会把大文件的 ft 改成 bigfile，csv 的 ftplugin 因此不会执行，
--- 所以这里必须单独兜住。schedule 是为了让启用落在 snacks.bigfile 的 setup 之后，
--- 以便覆盖它的 conceallevel=0 / statuscolumn=""。
function M.setup()
  local group = vim.api.nvim_create_augroup("SetupCsvViewTrigger", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "bigfile",
    callback = function(args)
      local bufnr = args.buf
      if vim.bo[bufnr].buftype ~= "" then
        return
      end
      if not is_csv_like(bufnr) then
        return
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          require("utils.csv_view").enable(bufnr)
        end
      end)
    end,
  })

  vim.api.nvim_create_user_command("CsvViewToggle", function()
    require("utils.csv_view").toggle()
  end, { desc = "Toggle CSV table view for current buffer" })

  return M
end

return M