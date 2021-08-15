local M = {}
function M.config()
  local pairs = { "''", '""', "``", "()", "{}", "[]" }
  local opts = {
    tabkey = "", -- key to trigger tabout
    backwards_tabkey = "", -- key to trigger tabout
    act_as_tab = true, -- shift content if tab out is not possible
    completion = true, -- if the tabkey is used in a completion pum
    tabouts = {},
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {}, -- tabout will ignore these filetypes
  }
  for i, v in ipairs(pairs) do
    table.insert(opts.tabouts, { open = v[0], close = v[1] })
  end
  require("tabout").setup(opts)
end
return M
