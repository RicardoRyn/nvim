return {
  -- 新建名为neovim的虚拟环境，然后安装pynvim, jupyter_client, jupytext
  -- 在各自的项目虚拟环境中，需要通过`python -m ipykernel install --user --name <project_name>`创建对应的内核
  -- jupyter kernelspec list 列出来所有可用的kernel
  -- jupyter kernelspec remove <kernel_name> 移除安装的kernel
  "benlubas/molten-nvim",
  cond = function()
    return vim.loop.os_uname().sysname == "Windows_NT" and not vim.g.vscode
  end,
  event = "VeryLazy",
  version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
  dependencies = { "willothy/wezterm.nvim" },
  build = ":UpdateRemotePlugins",
  init = function()
    vim.env.PATH = vim.fn.expand("E:/python/envs/neovim/Scripts") .. ":" .. vim.env.PATH -- 保证neovim环境中的jupytext可用
    vim.g.python3_host_prog = vim.fn.expand("E:/python/envs/neovim/python.exe")

    vim.g.molten_output_win_max_height = 20
    vim.g.molten_wrap_output = true
    vim.g.molten_image_location = "both" -- 图像呈现位置
    vim.g.molten_output_crop_border = true -- 当输出窗口本应停留在屏幕底部时，'裁剪'其底部边框
    vim.g.molten_cover_empty_lines = true -- 输出窗口和虚拟文本将显示在代码单元格最后一行的正下方。
    -- Molten.nvim 高亮组链接到已有颜色组
    vim.g.molten_use_border_highlights = true -- 当为真时，根据单元格状态（运行中/完成/错误）使用不同的高亮显示输出边框
    vim.api.nvim_set_hl(0, "MoltenOutputBorder", { link = "FloatBorder" }) -- 默认输出窗口边框
    vim.api.nvim_set_hl(0, "MoltenOutputBorderFail", { link = "ErrorMsg" }) -- 失败输出边框
    vim.api.nvim_set_hl(0, "MoltenOutputBorderSuccess", { link = "diffAdded" }) -- 成功输出边框
    -- vim.api.nvim_set_hl(0, "MoltenOutputWin", { link = "NormalFloat" }) -- 输出窗口内部
    -- vim.api.nvim_set_hl(0, "MoltenOutputWinNC", { link = "NormalFloat" }) -- 非当前输出窗口
    -- vim.api.nvim_set_hl(0, "MoltenOutputFooter", { link = "FloatFooter" }) -- 输出窗口底部提示
    -- vim.api.nvim_set_hl(0, "MoltenCell", { link = "CursorLine" }) -- 代码单元
    -- vim.api.nvim_set_hl(0, "MoltenVirtualText", { link = "Comment" }) -- 虚拟文本输出
    -- wezterm专用配置
    vim.g.molten_auto_open_output = false -- cannot be true if molten_image_provider = "wezterm"
    vim.g.molten_output_show_more = true
    vim.g.molten_image_provider = "wezterm"
    vim.g.molten_output_virt_lines = true
    vim.g.molten_split_direction = "right" --direction of the output window, options are "right", "left", "top", "bottom"
    vim.g.molten_split_size = 35 --(0-100) % size of the screen dedicated to the output window
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_auto_image_popup = false
    vim.g.molten_enter_output_behavior = "open_and_enter"
  end,

  -- stylua: ignore
  config = function()
    -- 初始化内核
    vim.keymap.set("n", "<leader>mI", ":MoltenInit<CR>", { silent = true, desc = "Molten Initialize" })
    -- vim.keymap.set("n", "<leader>mr", ":MoltenRestart<CR>", { silent = true, desc = "Molten Restart" })
    vim.keymap.set("n", "<leader>mR", ":MoltenRestart!<CR>", { silent = true, desc = "Molten Restart (clean outputs)" })
    -- 运行/中断
    vim.keymap.set("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "Evaluate", silent = true })
    vim.keymap.set("v", "<leader>me", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Execute (visual selection)", silent = true })
    vim.keymap.set("n", "<leader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "Run Line" })
    vim.keymap.set("n", "<leader>mr", ":MoltenReevaluateCell<CR>", { desc = "Re-eval Run (cell)", silent = true })
    vim.keymap.set("n", "<leader>mi", ":MoltenInterrupt<CR>", { silent = true, desc = "Molten Interrupt" })
    -- 输出
    vim.keymap.set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "Output Show", silent = true })
    vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>", { desc = "Output Hide", silent = true })
    vim.keymap.set("n", "<leader>od", ":MoltenDelete<CR>", { desc = "Molten Delete (current cell)", silent = true })
    vim.keymap.set("n", "<leader>oD", ":MoltenDelete!<CR>", { desc = "Molten Delete (all cells)", silent = true })
    vim.keymap.set("n", "<leader>ox", ":MoltenOpenInBrowser<CR>", { desc = "Output in Browser", silent = true })

  end,
}
