------------------ Gernal ------------------
vim.opt.confirm = true -- 关闭窗口时确认
vim.opt.mouse = "a" -- 启用鼠标
vim.opt.number = true -- 行号
vim.opt.relativenumber = false -- 相对行号
vim.opt.wrap = true -- 软换行
vim.opt.linebreak = true -- 软换行时，在合适位置换行
vim.opt.conceallevel = 0 -- 不隐藏任何文本
vim.opt.clipboard = "" -- 禁止neovim寄存器和系统剪贴板共用
-- vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- 同步系统的剪贴板

-------------------- UI --------------------
vim.o.winborder = "single" -- 窗口边框
vim.o.signcolumn = "yes" -- 在行号左边显示警告、错误、Git 修改等标记的列
vim.opt.smoothscroll = true -- 启用 平滑滚动（滚动时不会跳动，画面更流畅）
vim.opt.scrolloff = 4 -- 上下至少保留 4 行可见内容
vim.opt.laststatus = 3 -- 即使有多个窗口，底部只有一个统一状态栏，配合lualine使用
vim.opt.shortmess:append({
  W = true, -- 禁止显示 “written” 消息（保存文件后的提示信息）
  I = true, -- 禁止显示启动时的 Neovim 版本信息
  c = true, -- 在使用 completion-menu 时，不显示额外的完成信息（比如 “match 1 of 2”）
  C = true, -- 禁止显示完成菜单中的消息提示（更进一步隐藏补全提示信息）
})
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.inccommand = "nosplit" -- 增量替换（substitute）预览
vim.opt.jumpoptions = "view" -- 跳转后 恢复光标所在窗口的视图（例如滚动位置、折叠状态）
vim.opt.cursorline = true -- 显示光标当前行
vim.opt.pumblend = 10 -- 弹出菜单 0（完全不透明）到 100（完全透明）
vim.opt.pumheight = 10 -- 弹出菜单显示的最大条目数
vim.opt.ruler = false -- 如果开启状态栏会显示类似 12,34，因为有statusline，不需要
vim.opt.showmode = false -- 显示模式，因为有statusline，不需要
vim.opt.sidescrolloff = 8 -- 保持 左右各 8 列的缓冲区可见，可以避免光标靠边时画面突然左右滚动
vim.opt.splitbelow = true -- 打开水平分屏时，新窗口会 出现在当前窗口的下方
vim.opt.splitright = true -- 打开垂直分屏时，新窗口会 出现在当前窗口的右侧
vim.opt.splitkeep = "screen" -- 保持当前窗口的内容位置不动，屏幕不会因为新窗口而上下或左右移动
vim.opt.termguicolors = true -- 终端真彩色支持（24-bit RGB color）
vim.opt.updatetime = 200 -- 光标停止不动多久触发事件，可以让一些插件（比如自动保存、LSP 文本高亮或诊断提示）更及时响应
vim.opt.winminwidth = 5 -- 窗口的最小宽度为 5 列
vim.opt.colorcolumn = "120" -- 在编辑器中显示一个虚拟竖线（color column），通常用来提醒代码行不要太长
vim.opt.list = true -- 显示不可见字符（空格、Tab、换行等）
vim.opt.listchars = { tab = ">-", trail = "-" } -- 用>-表示tab

----------------- Term -------------------
vim.opt.shell = "zsh" -- 使用 zsh 作为外部 shell
vim.opt.shellcmdflag = "-c" -- 当 Neovim 执行命令时，用 -c 调用命令
vim.opt.shellquote = "" -- 无须用双引号包裹命令
vim.opt.shellxquote = "" -- 不使用额外外层引用符
vim.opt.shellslash = true -- 可选：防止 Windows 上路径被转义

------------------- Code ------------------
vim.g.autoformat = false -- 禁止自动格式化
vim.g.markdown_recommended_style = 0 -- 不要强制 Markdown 的默认风格
vim.opt.timeoutlen = vim.g.vscode and 1000 or 500 -- 触发键盘提示时长
vim.opt.completeopt = "menu,menuone,noselect" -- 打开补全菜单时不自动选中第一项
vim.opt.wildmode = "longest:full,full" -- 命令行补全模式,第一次按 Tab，会自动补全到 最长公共前缀,再按 Tab，会显示 完整匹配列表
vim.opt.spelllang = { "en" } -- 拼写检查的语言为英语（English）
vim.opt.undofile = true -- 即使关闭 Neovim，保留撤销历史
vim.opt.undolevels = 10000 -- 最大可撤销操作数量
vim.opt.virtualedit = "block" -- 光标在可视块模式（Visual Block Mode）中移动到没有文本的位置
vim.opt.grepformat = "%f:%l:%c:%m" --解析 grep 命令的输出格式为 file_path:line_number:column_number:matched_text
vim.opt.grepprg = "rg --vimgrep" -- 把 Neovim 的 grep 程序 换成 ripgrep
vim.opt.ignorecase = true -- 如果输入没有大写，则大小写不敏感
vim.opt.smartcase = true -- 如果输入有大写，则大小写敏感
vim.opt.shiftwidth = 2 -- 缩进（Indent）时每一级的空格数为 2
vim.opt.smartindent = false -- 智能缩进
vim.opt.tabstop = 2 -- 控制 tab显示宽度
vim.opt.softtabstop = 2 -- 控制 按键插入/删除tab的空格数量
vim.opt.shiftround = true -- 自动把缩进量 向 shiftwidth 的倍数对齐
vim.opt.expandtab = true -- 使用空格而不是真正的tab
