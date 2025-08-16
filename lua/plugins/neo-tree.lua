if vim.g.vscode then
  return {}
else
  return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Open NeoTree (cwd)",
      },
    },

    -- 钩子函数，想在其他场景自动关闭 Neo-tree，调用这个函数就可以
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,

    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("NeotreeAutoOpen", { clear = true }),
        desc = "Auto-open Neo-tree on startup and focus main buffer",
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
      sources = { "filesystem", "git_status" }, -- "filesystem" | "buffers" | "git_status"
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
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = require("config.icons").git.unstaged,
            staged = require("config.icons").git.staged,
            modified = require("config.icons").git.modified,
            added = require("config.icons").git.added,
            ignored = require("config.icons").git.ignored,
          },
        },
      },
    },

    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#dce0e8" }) -- 设置 NeoTree 当前行颜色为灰色
    end,
  }
end
