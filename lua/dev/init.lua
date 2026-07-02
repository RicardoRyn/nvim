local names = {
}

local dev_path
if require("utils.system").is_win then
  dev_path = "E:/git_repositories/nvim_dev/"
else
  dev_path = "~/git_repositories/nvim_dev/"
end

for _, name in ipairs(names) do
  vim.opt.runtimepath:append(dev_path .. name)
  pcall(require, "dev." .. name:gsub("%.", "-"))
end
