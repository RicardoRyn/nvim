local active_specs = {
  -- CORE
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  -- DAP
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/igorlfs/nvim-dap-view" },
  { src = "https://github.com/mfussenegger/nvim-dap-python" },
  { src = "https://github.com/jbyuki/one-small-step-for-vimkind" },
  -- TOOLS
  { src = "https://github.com/zbirenbaum/copilot.lua" },
  { src = "https://github.com/folke/sidekick.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/linux-cultist/venv-selector.nvim" },
  { src = "https://github.com/kevinhwang91/nvim-ufo" },
  { src = "https://github.com/kevinhwang91/promise-async" }, -- dependency for nvim-ufo
  { src = "https://github.com/NStefan002/screenkey.nvim" },
  { src = "https://github.com/danymat/neogen" },
  { src = "https://github.com/lervag/vimtex" },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/baggiponte/rex-navigator.nvim" },
  -- UI
  { src = "https://github.com/OXY2DEV/markview.nvim" },
  { src = "https://github.com/rebelot/heirline.nvim" },
  { src = "https://github.com/hedyhli/outline.nvim" },
  { src = "https://github.com/brianhuster/live-preview.nvim" },
  -- VCS
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nicolasgb/jj.nvim" },
  { src = "https://github.com/julienvincent/hunk.nvim", version = "jv/3-way-merge-tool" },
  { src = "https://github.com/MunifTanjim/nui.nvim" }, -- dependency for hunk.nvim
  { src = "https://github.com/CoreyKaylor/diffbandit.nvim" },
}

local disabled_specs = {
  -- { src = "https://github.com/mikesmithgh/kitty-scrollback.nvim" },
  -- { src = "https://github.com/christoomey/vim-tmux-navigator" },
  -- { src = "https://github.com/folke/todo-comments.nvim" },
  -- { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  -- { src = "https://tangled.org/ronshavit.com/jjannotate.nvim" },
  -- { src = "https://github.com/saghen/blink.cmp" },
  -- { src = "https://github.com/saghen/blink.lib" },
  -- { src = "https://github.com/rafamadriz/friendly-snippets" },
  -- { src = "https://github.com/starbaser/codewindow.nvim" },
  -- { src = "https://github.com/FylerOrg/fyler.nvim" },
  -- { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  -- { src = "https://github.com/tjgao/quickbuf.nvim" },
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

local function pack_clean(opts)
  local protected_names = {}

  -- protect the plugin in specs
  for _, spec in ipairs(active_specs) do
    protected_names[get_names_from_spec(spec)] = true
  end
  for _, spec in ipairs(disabled_specs) do
    local name = get_names_from_spec(spec)
    protected_names[name] = true
  end

  local to_delete = {}
  for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
    local name = plugin.spec.name
    if not plugin.active and not protected_names[name] then
      to_delete[#to_delete + 1] = name
    end
  end
  table.sort(to_delete)

  if #to_delete == 0 then
    vim.notify("No orphaned vim.pack plugins")
  elseif opts.bang then
    vim.pack.del(to_delete)
  else
    vim.notify("Orphaned vim.pack plugins: " .. table.concat(to_delete, ", ") .. " (use :PackClean! to remove)")
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

vim.api.nvim_create_user_command("PackClean", pack_clean, {
  bang = true,
  desc = "Preview orphaned vim.pack plugins (! to remove)",
})

vim.pack.add(active_specs)

if not vim.g.vscode then
  vim.keymap.set("n", "<leader>Pc", "<cmd>PackClean<cr>", { desc = "Pack clean (no remove)" })
  vim.keymap.set("n", "<leader>PC", "<cmd>PackClean!<cr>", { desc = "Pack clean" })
  vim.keymap.set("n", "<leader>Ps", "<cmd>PackStatus<cr>", { desc = "Pack status" })
  vim.keymap.set("n", "<leader>Pu", "<cmd>PackUpdate<cr>", { desc = "Pack update" })
  vim.keymap.set("n", "<leader>PU", "<cmd>PackUpdate!<cr>", { desc = "Pack update (no confirmation)" })

  -- Snacks is special, load it here for debug functionality
  require("mini.misc").safely("now", function()
    require("utils.snacks_nvim")
  end)
end
