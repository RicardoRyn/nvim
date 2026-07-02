---Show a notification with a pretty printed dump of the object(s)
---with lua treesitter highlighting and the location of the caller
_G.dd = function(...)
  Snacks.debug.inspect(...)
end

---Show a notification with a pretty backtrace
---opts = {
---    level = vim.log.levels.INFO,
---    title = "My backtrace",
---    icon = "󰴽",
---    ...
---}
_G.bt = function(msg, opts)
  Snacks.debug.backtrace(msg, opts)
end

-- Very simple function to profile a lua function.
-- * **flush**: set to `true` to use `jit.flush` in every iteration.
-- * **count**: defaults to 100
---@param fn fun()
---@param opts? {count?: number, flush?: boolean, title?: string}
_G.pf = function(fn, opts)
  Snacks.debug.profile(fn, opts)
end

-- Log a message to the file `./debug.log`.
-- - a timestamp will be added to every message.
-- - accepts multiple arguments and pretty prints them.
-- - if the argument is not a string, it will be printed using `vim.inspect`.
-- - if the message is smaller than 120 characters, it will be printed on a single line.
--
-- ```lua
-- Snacks.debug.log("Hello", { foo = "bar" }, 42)
-- -- 2024-11-08 08:56:52 Hello { foo = "bar" } 42
-- ```
_G.log = function(...)
  Snacks.debug.log(...)
end

---@param name string?
_G.tr = function(name)
  Snacks.debug.trace(name)
end

---@param modname string
---@param mod? table
---@param suffix? string
_G.tm = function(modname, mod, suffix)
  Snacks.debug.tracemod(modname, mod, suffix)
end

---@param opts? {min?: number, show?:boolean}
_G.st = function(opts)
  Snacks.debug.stats(opts)
end

if vim.fn.has("nvim-0.11") == 1 then
  vim._print = function(_, ...)
    dd(...)
  end
else
  vim.print = dd
end
