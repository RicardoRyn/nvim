return {
  "mrdwarf7/lazyjui.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  keys = {
    {
      -- Default is <Leader>jj
      -- An example of a custom mapping to open the interface
      "<Leader>gj",
      function()
        require("lazyjui").open()
      end,
    },
  },
  opts =  {
    -- Optionally: 
    -- winblend = 69, -- If you want some level of transparency
    -- support for custom command pass-through
    -- In this example, we use the revset `all()` command 
    --
    -- Will default to just `jjui`
    cmd = { "jjui", "-r", "all()" }, 
  }
}
