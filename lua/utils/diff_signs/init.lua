if vim.g.vscode then return end

local config = require("utils.diff_signs.config")
local buffers = require("utils.diff_signs.buffers")
local jj = require("utils.diff_signs.jj")

local M = {}

--- start tracking any existing buffers that meet tracking criteria
local init_existing_bufs = function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      -- get the name now as the buffer may not be valid by the time
      -- vim.schedule runs the function.
      local name = vim.api.nvim_buf_get_name(buf)
      vim.schedule(function()
        buffers.start_tracking(buf, name)
      end)
    end
  end
end

--- subcommand name and funtion
--- @class DiffSigns.Subcommand
--- @field name string
--- @field handler function

--- table of subcommands for the DiffSigns command
--- @type DiffSigns.Subcommand[]
local subcommands = {
  {
    name = "enable",
    handler = function()
      if not config.enabled then
        config.enabled = true
        init_existing_bufs()
      end
    end,
  },
  {
    name = "disable",
    handler = function()
      if config.enabled then
        config.enabled = false
        buffers.stop_tracking_all()
      end
    end,
  },
  {
    name = "prev",
    handler = function()
      if config.enabled then
        buffers.prev_hunk()
      end
    end,
  },
  {
    name = "next",
    handler = function()
      if config.enabled then
        buffers.next_hunk()
      end
    end,
  },
  {
    name = "preview",
    handler = function()
      if config.enabled then
        buffers.preview()
      end
    end,
  },
  {
    name = "commit",
    handler = function()
      local buf = vim.api.nvim_win_get_buf(0)
      local name = vim.api.nvim_buf_get_name(buf)
      local root = jj.root_folder(name)
      if root ~= nil then
        vim.print("commit_id for @- is " .. jj.previous_commit_id(root))
      else
        vim.print("no repo for file in current window")
      end
    end,
  },
  {
    name = "hunks",
    handler = function()
      if config.enabled then
        buffers.show_hunks()
      end
    end,
  },
  {
    name = "reset",
    handler = function()
      if config.enabled then
        buffers.reset_hunk()
      end
    end,
  },
}

--- Handle the DiffSigns command
--- The command takes a subcommand argument that determins which
--- function to perform
--- @param args vim.api.keyset.create_user_command.command_args
local command = function(args)
  if #args.fargs == 0 then
    vim.print("diff_signs: missing subcommand")
    return
  end
  local cmd, arg = string.match(args.fargs[1], "(%l+)=?(%g*)")
  for _, subcommand in ipairs(subcommands) do
    if subcommand.name == cmd then
      subcommand.handler(arg)
      return
    end
  end
  vim.print("diff_signs: unknown subcommand " .. cmd)
end

--- Get completions for subcommands
---@param arg_lead string
---@return string[]
local function get_subcommand_completions(arg_lead)
  local completions = {}
  for _, subcommand in ipairs(subcommands) do
    if subcommand.name:find(arg_lead, 1, true) == 1 then
      table.insert(completions, subcommand.name)
    end
  end
  return completions
end

--- Initialize the plugin
M.init = function()
  if vim.g.diff_signs_init == true then
    return
  end
  vim.g.diff_signs_init = true
  config.init()

  -- add the DiffSigns command
  vim.api.nvim_create_user_command("DiffSigns", command, {
    desc = "control jj gutter diff signs",
    nargs = 1,
    complete = get_subcommand_completions,
  })

  -- add autocommands
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("SetupDiffSignsBufRead", { clear = true }),
    callback = function(ev)
      vim.schedule(function()
        buffers.start_tracking(ev.buf, ev.file)
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufUnload" }, {
    group = vim.api.nvim_create_augroup("SetupDiffSignsBufUnload", { clear = true }),
    callback = function(ev)
      vim.schedule(function()
        buffers.stop_tracking(ev.buf)
      end)
    end,
  })

  -- verify jj is installed and can be accessed
  -- if not disable the plugin
  if vim.fn.executable("jj") == 0 then
    config.enabled = false
    vim.notify("diff_signs: disabled - can not find jj in path", vim.log.levels.ERROR)
  end

  -- process any existing buffers
  if config.enabled then
    init_existing_bufs()
  end
end

M.init()

vim.keymap.set("n", "gH", ":DiffSigns prev<CR>", { desc = "Prev hunk" })
vim.keymap.set("n", "gh", ":DiffSigns next<CR>", { desc = "Next hunk" })
vim.keymap.set("n", "<leader>gp", ":DiffSigns preview<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", ":DiffSigns reset<CR>", { desc = "Reset hunk" })

return M
