---@class LazySpec
---@field setup fun()                     Called once, on first trigger.
---@field keys? table[]                   Key specs: { mode, lhs, rhs, opts? }.
---@field cmd? string[]                   Plugin commands to lazy-load on, e.g. { "Outline" }.

local M = {}

local function key_loader(spec)
  for _, key in ipairs(spec.keys or {}) do
    if type(key[3]) == "string" then
      local rhs = key[3]
      local opts = key[4] or {}
      vim.keymap.set(key[1], key[2], function()
        spec.load()
        if opts.expr then
          return rhs
        end
        local keys = vim.api.nvim_replace_termcodes(rhs, true, true, true)
        local mode = opts.remap and "m" or "n"
        vim.api.nvim_feedkeys(keys, mode, false)
      end, opts)
    else
      vim.keymap.set(key[1], key[2], function()
        spec.load()
        return key[3]()
      end, key[4] or {})
    end
  end
end

local function cmd_loader(spec)
  for _, cmd in ipairs(spec.cmd or {}) do
    -- Use CmdUndefined event: when user tries to execute a command that doesn't
    -- exist, this autocmd fires, loads the plugin (which registers the real command),
    -- and Neovim automatically retries the command.
    vim.api.nvim_create_autocmd("CmdUndefined", {
      pattern = cmd,
      once = true,
      callback = function()
        spec.load()
      end,
    })
  end
end

--- Load a plugin lazily via keys and/or commands.
--- All triggers share a single `load` guard so setup() only runs once.
---
--- Usage:
---   require("utils.lazy").load({
---     setup = function() require("telescope").setup({ ... }) end,
---     keys  = { { "n", "<leader>ff", function() ... end, { desc = "Find files" } } },
---     cmd   = { "Telescope" },
---   })
---
---@param spec LazySpec
---@return fun() load  Call this to force eager-loading.
function M.load(spec)
  local loaded = false

  local function load()
    if loaded then
      return
    end
    spec.setup()
    loaded = true
  end

  if spec.keys then
    key_loader({ load = load, keys = spec.keys })
  end

  if spec.cmd then
    cmd_loader({ load = load, cmd = spec.cmd })
  end

  return load
end

return M
