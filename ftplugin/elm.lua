require("lsp.config").lspconfig "elmls" {
  -- FIXME: idk what to do about this
  init_options = {
    elmAnalyseTrigger = "change",
    elmFormatPath = LSP_INSTALL_PATH .. "/elm/node_modules/.bin/elm-format",
    elmPath = LSP_INSTALL_PATH .. "/elm/node_modules/.bin/elm",
    elmTestPath = LSP_INSTALL_PATH .. "/elm/node_modules/.bin/elm-test",
  },
}
