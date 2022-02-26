vim.opt_local.commentstring = "# %s"

require("lv-pairs.sandwich").add_recipe {
  buns = { "{{ ", " }}" },
  nesting = false,
  skip_break = true,
  input = { "s" },
}
