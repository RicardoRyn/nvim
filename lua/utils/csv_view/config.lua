local M = {}

M.defaults = {
  parser = {
    delimiter = {
      ft = {
        csv = ",",
        tsv = "\t",
      },
      fallbacks = { ",", "\t", ";", "|", ":" },
    },
    quote_char = '"',
  },
  big_file = {
    size = 1.5 * 1024 * 1024,
    line_length = 1000,
    sample_lines = 300,
    max_lookbehind = 50,
  },
  view = {
    border_char = "│",
    left_spacing = 0,
    right_spacing = 0,
    display_mode = "border",
    sticky_header = {
      enabled = true,
      separator = "─",
    },
  },
}

function M.merge(user_opts)
  return vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), user_opts or {})
end

return M
