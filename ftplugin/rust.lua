if O.plugin.rust_tools then
  require("lsp.rust").ftplugin()
end

require("lv-pairs.sandwich").add_local_recipes {
  {
    buns = { "|| {", "}" },
    input = { "l" },
  },
  {
    buns = { "Some(", ")" },
    input = { "s" },
  },
  {
    buns = { "Ok(", ")" },
    input = { "k" },
  },
  {
    buns = { "Err(", ")" },
    input = { "e" },
  },
}
-- TODO: Snippets using TM_SELECTED_TEXT
