-- TODO figure out why this don't work
vim.fn.sign_define(
  "LspDiagnosticsSignError",
  { texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignWarning",
  { texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignHint",
  { texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignInformation",
  { texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
)

-- Set Default Prefix.
-- Note: You can set a prefix per lsp server in the lv-globals.lua file
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  O.lsp.diagnostics
)
vim.lsp.handlers["textDocument/codeLens"] = vim.lsp.with(vim.lsp.codelens.on_codelens, O.lsp.codeLens)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = O.lsp.border,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = O.lsp.border,
  focusable = false,
})

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
  "   (Text) ",
  "   (Method)",
  "   (Function)",
  "   (Constructor)",
  " ﴲ  (Field)",
  "[] (Variable)",
  "   (Class)",
  " ﰮ  (Interface)",
  "   (Module)",
  " 襁 (Property)",
  "   (Unit)",
  "   (Value)",
  " 練 (Enum)",
  "   (Keyword)",
  "   (Snippet)",
  "   (Color)",
  "   (File)",
  "   (Reference)",
  "   (Folder)",
  "   (EnumMember)",
  " ﲀ  (Constant)",
  " ﳤ  (Struct)",
  "   (Event)",
  "   (Operator)",
  "   (TypeParameter)",
}

require("lv-utils").define_augroups {
  _general_lsp = {
    { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "lspinfo", "nnoremap <buffer> I :LspInstall " },
  },
  -- _codelens_refesh = {
  --   { "BufEnter,CursorHold,InsertLeave", "*", "lua vim.lsp.codelens.refresh()" },
  -- },
  -- _lsp_hover = {
  --   { "CursorHold, CursorHoldI", "*", "lua vim.lsp.buf.hover()" },
  -- },
}

noremap("n", "gm", [[<cmd>lua require("lsp.functions").format_range_operator()<CR>]])
-- noremap("n", "=", [[<cmd>lua require("lsp.functions").format_range_operator()<CR>]])
noremap("v", "gm", "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
-- noremap("v", "=", "<cmd>lua vim.lsp.buf.range_formatting()<cr>")
noremap("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<cr>")
-- noremap("n", "==", "<cmd>lua vim.lsp.buf.formatting()<cr>")

-- -- TODO: enable this in a ftplugin maybe
-- if O.lang.emmet.active then
--   require "lsp.emmet-ls"
-- end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
-- local servers = {"pyright", "tsserver"}
-- for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup {on_attach = on_attach} end
