-- Signs
local sign_define = vim.fn.sign_define
sign_define(
  "LspDiagnosticsSignError",
  { texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
)
sign_define(
  "LspDiagnosticsSignWarning",
  { texthl = "LspDiagnosticsSignWarning", text = "", numhl = "LspDiagnosticsSignWarning" }
)
sign_define(
  "LspDiagnosticsSignHint",
  { texthl = "LspDiagnosticsSignHint", text = "", numhl = "LspDiagnosticsSignHint" }
)
sign_define(
  "LspDiagnosticsSignInformation",
  { texthl = "LspDiagnosticsSignInformation", text = "", numhl = "LspDiagnosticsSignInformation" }
)

-- Handlers
local lsp = vim.lsp
local handlers = vim.lsp.handlers
local lspwith = vim.lsp.with
handlers["textDocument/publishDiagnostics"] = lspwith(vim.lsp.diagnostic.on_publish_diagnostics, O.lsp.diagnostics)
handlers["textDocument/codeLens"] = lspwith(vim.lsp.codelens.on_codelens, O.lsp.codeLens)
handlers["textDocument/hover"] = lspwith(handlers.hover, {
  border = O.lsp.border,
})
handlers["textDocument/signatureHelp"] = lspwith(handlers.signature_help, {
  border = O.lsp.border,
  focusable = false,
})

-- symbols for autocomplete
lsp.protocol.CompletionItemKind = {
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

-- Lsp autocommands
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

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
-- local servers = {"pyright", "tsserver"}
-- for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup {on_attach = on_attach} end
