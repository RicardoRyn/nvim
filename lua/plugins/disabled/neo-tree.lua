return {
  "nvim-neo-tree/neo-tree.nvim",
  cond = not vim.g.vscode,
  cmd = "Neotree",
  -- stylua: ignore
  keys = {
    { "<leader>e",
      function() require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() }) end,
      desc = "NeoTree (cwd)",
    },
    { "<leader>ge",
      function() require("neo-tree.command").execute({ source = "git_status", toggle = true }) end,
      desc = "Git Explorer",
    },
    { "<leader>be",
      function() require("neo-tree.command").execute({ source = "buffers", toggle = true }) end,
      desc = "Buffer Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })
  end,
  opts = {
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["t"] = "none",
        ["c"] = "none",
        ["cc"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["cd"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local dir = vim.fn.fnamemodify(path, ":h") -- 获取目录部分
            vim.fn.setreg("+", dir, "c") -- 复制到系统剪贴板
          end,
          desc = "Copy Directory Path to Clipboard",
        },
        ["cf"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            local name = vim.fn.fnamemodify(path, ":t")
            vim.fn.setreg("+", name, "c")
            -- 可选提示
            -- vim.notify("Copied name: " .. name)
          end,
          desc = "Copy File/Dir Name to Clipboard",
        },
        ["o"] = "open",
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
        ["oc"] = "none",
        ["od"] = "none",
        ["og"] = "none",
        ["om"] = "none",
        ["on"] = "none",
        ["os"] = "none",
        ["ot"] = "none",
        [","] = "none",
        [",c"] = "order_by_created",
        [",d"] = "order_by_diagnostics",
        [",g"] = "order_by_git_status",
        [",m"] = "order_by_modified",
        [",n"] = "order_by_name",
        [",s"] = "order_by_size",
        [",t"] = "order_by_type",
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },
    default_component_configs = {
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = require("utils.icons").git.unstaged,
          staged = require("utils.icons").git.staged,
          modified = require("utils.icons").git.modified,
          added = require("utils.icons").git.added,
          ignored = require("utils.icons").git.ignored,
        },
      },
      -- neo-tree中使用mini.icons参考[#1527](https://github.com/nvim-neo-tree/neo-tree.nvim/pull/1527)
      icon = {
        provider = function(icon, node) -- setup a custom icon provider
          local text, hl
          local mini_icons = require("mini.icons")
          if node.type == "file" then -- if it's a file, set the text/hl
            text, hl = mini_icons.get("file", node.name)
          elseif node.type == "directory" then -- get directory icons
            text, hl = mini_icons.get("directory", node.name)
            -- only set the icon text if it is not expanded
            if node:is_expanded() then
              text = nil
            end
          end
          -- set the icon text/highlight only if it exists
          if text then
            icon.text = text
          end
          if hl then
            icon.highlight = hl
          end
        end,
      },
      kind_icon = {
        provider = function(icon, node)
          local mini_icons = require("mini.icons")
          icon.text, icon.highlight = mini_icons.get("lsp", node.extra.kind.name)
        end,
      },
    },
  },
  config = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })

    -- 设置 NeoTree 当前行颜色为灰色
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#dce0e8" })
  end,
}
