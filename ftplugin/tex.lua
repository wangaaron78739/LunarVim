vim.opt_local.wrap = true
vim.opt_local.spell = true

if not require("lv-utils").check_lsp_client_active "texlab" then
  require("lspconfig").texlab.setup {
    cmd = { DATA_PATH .. "/lspinstall/latex/texlab" },
    on_attach = require("lsp.functions").common_on_attach,
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = O.lang.latex.diagnostics.virtual_text,
        signs = O.lang.latex.diagnostics.signs,
        underline = O.lang.latex.diagnostics.underline,
        update_in_insert = true,
      }),
    },
    -- filetypes = O.lang.latex.filetypes,
    settings = {
      texlab = {
        auxDirectory = O.lang.latex.aux_directory,
        bibtexFormatter = O.lang.latex.bibtex_formatter,
        build = {
          args = O.lang.latex.build.args,
          executable = O.lang.latex.build.executable,
          forwardSearchAfter = O.lang.latex.build.forward_search_after,
          onSave = O.lang.latex.build.on_save,
        },
        chktex = {
          onEdit = O.lang.latex.chktex.on_edit,
          onOpenAndSave = O.lang.latex.chktex.on_open_and_save,
        },
        diagnosticsDelay = O.lang.latex.diagnostics_delay,
        formatterLineLength = O.lang.latex.formatter_line_length,
        forwardSearch = {
          args = O.lang.latex.forward_search.args,
          executable = O.lang.latex.forward_search.executable,
        },
        latexFormatter = O.lang.latex.latex_formatter,
        latexindent = {
          modifyLineBreaks = O.lang.latex.latexindent.modify_line_breaks,
        },
      },
    },
    flags = O.lsp.flags,
  }
end
