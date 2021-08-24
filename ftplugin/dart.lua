if require("lv-utils").check_lsp_client_active "dartls" then
  return
end

if not O.plugin.flutter_tools then
  require("lsp.config").lspconfig  "dartls" {
    cmd = { "dart", O.lang.dart.sdk_path, "--lsp" },
    on_attach = require("lsp.functions").common_on_attach,
    init_options = {
      closingLabels = false,
      flutterOutline = false,
      onlyAnalyzeProjectsWithOpenFiles = false,
      outline = false,
      suggestFromUnimportedLibraries = true,
    },
    flags = O.lsp.flags,
  }
end
