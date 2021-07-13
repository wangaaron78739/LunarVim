-- npm i -g bash-language-server
if not require("lv-utils").check_lsp_client_active "bashls" then
  require("lspconfig").bashls.setup {
    cmd = { DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server", "start" },
    on_attach = require("lsp").common_on_attach,
    filetypes = { "zsh" },
  flags = O.lsp.flags,
  }
end

if O.lang.sh.efm.active == true then
  require("lsp.efm-ls").generic_setup { "zsh" }
end
