if not O.plugin.flutter_tools then
  require("lsp.config").lspconfig "dartls" {
    cmd = { "dart", "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot", "--lsp" },
    init_options = {
      closingLabels = false,
      flutterOutline = false,
      onlyAnalyzeProjectsWithOpenFiles = false,
      outline = false,
      suggestFromUnimportedLibraries = true,
    },
  }
end
