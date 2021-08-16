-- TODO what is a svelte filetype
require("lsp.functions").lspconfig("svelte") {
  cmd = {
    DATA_PATH .. "/lspinstall/svelte/node_modules/.bin/svelteserver",
    "--stdio",
  },
  on_attach = require("lsp.functions").common_on_attach,
  flags = O.lsp.flags
}
