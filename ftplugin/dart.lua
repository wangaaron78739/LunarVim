if require("lv-utils").check_lsp_client_active "dartls" then
  return
end

if not O.plugin .. flutter_tools.active then
  require("lspconfig").dartls.setup {
    cmd = { "dart", O.lang.dart.sdk_path, "--lsp" },
    on_attach = require("lsp").common_on_attach,
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

if O.lang.dart.autoformat then
  require("lv-utils").define_augroups {
    _dart_autoformat = {
      {
        "BufWritePre",
        "*.dart",
        "lua vim.lsp.buf.formatting_sync(nil, 1000)",
      },
    },
  }
end
