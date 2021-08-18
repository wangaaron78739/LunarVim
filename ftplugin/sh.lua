-- npm i -g bash-language-server
local ft = { "sh", "bash" }

if not require("lv-utils").check_lsp_client_active "bashls" then
  require("lsp.functions").lspconfig "bashls" {
    cmd = {
      DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server",
      "start",
    },
    on_attach = require("lsp.functions").common_on_attach,
    filetypes = ft,
    flags = O.lsp.flags,
  }
end
