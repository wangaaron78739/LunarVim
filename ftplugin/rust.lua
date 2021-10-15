if O.plugin.rust_tools then
  require("lv-rust-tools").ftplugin()
end

require("lv-sandwich").add_local_recipes {
  {
    buns = { "|| {", "}" },
    input = { "l" },
  },
}
