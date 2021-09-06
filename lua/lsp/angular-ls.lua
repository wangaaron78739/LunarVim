-- TODO find correct root filetype
-- :LspInstall angular
require("lsp.config").lspconfig "angularls" {
  cmd = {
    DATA_PATH .. "/lspinstall/angular/node_modules/@angular/language-server/bin/ngserver",
    "--stdio",
  },
}
