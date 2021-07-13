-- Because lspinstall don't support zig yet,
-- So we need zls preset in global lib
-- Further custom install zls in
-- https://github.com/zigtools/zls/wiki/Downloading-and-Building-ZLS
if not require("lv-utils").check_lsp_client_active "zls" then
  require("lspconfig").zls.setup {
    root_dir = require("lspconfig").util.root_pattern(".git", "build.zig", "zls.json"),
    on_attach = require("lsp").common_on_attach,
    cmd = { DATA_PATH .. "/lspinstall/zig/zls/zls" }, -- TODO: Is this really necessary
    flags = O.lsp.flags,
  }

  if O.lang.zig.autoformat then
    require("lv-utils").define_augroups {
      _zig_autoformat = {
        { "BufWritePre", "*.zig", "lua vim.lsp.buf.formatting_sync(nil, 1000)" },
      },
    }
  end
end

vim.opt_local.commentstring = [[// %s]]

vim.cmd "setl expandtab tabstop=8 softtabstop=4 shiftwidth=4"
