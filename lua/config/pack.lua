local active_specs = {
  -- Core
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/neovim-treesitter/nvim-treesitter" },
  { src = "https://github.com/folke/snacks.nvim" },
  -- Dap
  { src = "https://github.com/igorlfs/nvim-dap-view" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/mfussenegger/nvim-dap-python" },
  -- Edit
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.surround" },
  { src = "https://github.com/danymat/neogen" },
  -- Tools
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/FylerOrg/fyler.nvim" },
  { src = "https://github.com/folke/sidekick.nvim" },
  { src = "https://github.com/linux-cultist/venv-selector.nvim" },
  { src = "https://github.com/Wansmer/treesj" },
  -- UI
  { src = "https://github.com/starbaser/codewindow.nvim" },
  { src = "https://github.com/rebelot/heirline.nvim" },
  { src = "https://github.com/nvim-mini/mini.clue" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/kevinhwang91/nvim-ufo" },
  { src = "https://github.com/hedyhli/outline.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  { src = "https://github.com/OXY2DEV/markview.nvim" },
  -- VCS
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/julienvincent/hunk.nvim", version = "jv/3-way-merge-tool" },
  { src = "https://github.com/nicolasgb/jj.nvim" },
  { src = "https://tangled.org/ronshavit.com/jjannotate.nvim" },
  -- No config
  { src = "https://github.com/jbyuki/one-small-step-for-vimkind" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/kevinhwang91/promise-async" },
  { src = "https://github.com/neovim-treesitter/treesitter-parser-registry" },
}

local disabled_specs = {
  -- { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  -- { src = "https://github.com/nvim-mini/mini.files" },
  -- { src = "https://github.com/tjgao/quickbuf.nvim" },
  -- { src = "https://github.com/nvim-mini/mini.diff" },
  -- { src = "https://github.com/CoreyKaylor/diffbandit.nvim" },
}

local function get_names_from_vimpack(arg_lead)
  local installed = vim.pack.get(nil, { info = false })
  local names = {}
  for _, p in ipairs(installed) do
    local name = p.spec.name
    if name:lower():find(arg_lead:lower(), 1, true) == 1 then
      table.insert(names, name)
    end
  end
  table.sort(names)
  return names
end

local function get_names_from_spec(spec)
  local name
  if spec.name then
    name = spec.name
  else
    local src = spec.src
    name = src:match("([^/]+)$"):gsub("%.git$", "")
  end
  return name
end

---Auto delete the orhpan plugins.
---@param active table
---@param disabled table
local function sync()
  local protected_names = {}

  -- protect the plugin in specs
  for _, spec in ipairs(active_specs) do
    protected_names[get_names_from_spec(spec)] = true
  end
  for _, spec in ipairs(disabled_specs) do
    local name = get_names_from_spec(spec)
    protected_names[name] = true
  end

  -- scan the plugins in the disk
  local installed_plugins = {}
  local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
  local packages = vim.fn.expand(pack_dir .. "/*", false, true)
  for _, pkg in ipairs(packages) do
    for _, type_dir in ipairs({ "start", "opt" }) do
      local path = pkg .. "/" .. type_dir
      if vim.fn.isdirectory(path) == 1 then
        local dirs = vim.fn.expand(path .. "/*", false, true)
        for _, dir in ipairs(dirs) do
          local name = dir:match("([^/]+)$")
          if name ~= "README.md" and name ~= "doc" then
            table.insert(installed_plugins, name)
          end
        end
      end
    end
  end

  -- delete the orphaned plugins
  local to_delete = {}
  for _, installed in ipairs(installed_plugins) do
    if not protected_names[installed] then
      table.insert(to_delete, installed)
    end
  end
  if #to_delete > 0 then
    vim.schedule(function()
      vim.notify(" Clean Up Orphaned Plugins: " .. table.concat(to_delete, ", "), vim.log.levels.INFO)
      vim.pack.del(to_delete)
    end)
  end
end

vim.api.nvim_create_user_command(
  "PackUpdate",
  function(opts)
    local targets = #opts.fargs > 0 and opts.fargs or nil
    local force = opts.bang
    if targets then
      vim.notify("Checking updates for: " .. table.concat(targets, ", "), vim.log.levels.INFO)
    else
      vim.notify("Checking updates for all plugins...", vim.log.levels.INFO)
    end
    vim.pack.update(targets, { force = force })
  end,
  { nargs = "*", bang = true, complete = get_names_from_vimpack, desc = "Update plugins (use ! to skip confirmation)" }
)

vim.api.nvim_create_user_command("PackDel", function(opts)
  vim.pack.del(opts.fargs)
end, { nargs = "+", complete = get_names_from_vimpack, desc = "Delete plugins" })

vim.api.nvim_create_user_command("PackStatus", function(opts)
  local targets = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(targets, { offline = true })
end, { nargs = "*", complete = get_names_from_vimpack, desc = "Check plugins status without downloading" })

vim.pack.add(active_specs)
sync()

if not vim.g.vscode then
  vim.keymap.set("n", "<leader>Ps", "<cmd>PackStatus<cr>", { desc = "Pack status" })
  vim.keymap.set("n", "<leader>Pu", "<cmd>PackUpdate<cr>", { desc = "Pack update" })
  vim.keymap.set("n", "<leader>PU", "<cmd>PackUpdate!<cr>", { desc = "Pack update (no confirmation)" })
  -- Snacks is special, load it here for debug functionality
  require("utils.snacks_nvim")
end
