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

local function documentHighlight(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
end
local lsp_config = {}

lsp_config.diag_next = function()
  vim.lsp.diagnostic.goto_next { popup_opts = { border = O.lsp.border } }
end
lsp_config.diag_prev = function()
  vim.lsp.diagnostic.goto_prev { popup_opts = { border = O.lsp.border } }
end
-- TODO: figure out how to floating window the code actions
-- vim.lsp.handlers["textDocument/codeAction"] = vim.lsp.with(vim.lsp.handlers.codeAction, {
--   border = O.lsp.border,
-- })
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = O.lsp.border,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = O.lsp.border,
})

if O.document_highlight then
  function lsp_config.common_on_attach(client, bufnr)
    documentHighlight(client, bufnr)
  end
end

require("lv-utils").define_augroups {
  _general_lsp = {
    { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
  },
}

-- TODO: enable this in a ftplugin maybe
if O.lang.emmet.active then
  require "lsp.emmet-ls"
end

_G.Rename = {
  rename = function()
    local opts = {
      relative = "cursor",
      row = 0,
      col = 0,
      width = 30,
      height = 1,
      style = "minimal",
      border = "single",
    }
    local cword = vim.fn.expand "<cword>"
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, opts)
    local dorename = string.format("<cmd>lua Rename.dorename(%d, %d)<CR>", win)
    local dontrename = string.format("<cmd>lua Rename.close_rename(%d, %d)<CR>", win)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { cword })
    vim.api.nvim_buf_set_keymap(buf, "i", "<CR>", dorename, { silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<ESC>", dontrename, { silent = true })
  end,
  close_rename = function(win, buf)
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.api.nvim_win_close(win, true)
  end,
  dorename = function(win, buf)
    local new_name = vim.trim(vim.fn.getline ".")
    _G.Rename.close_rename(win, buf)
    vim.lsp.buf.rename(new_name)
  end,
}

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
-- local servers = {"pyright", "tsserver"}
-- for _, lsp in ipairs(servers) do nvim_lsp[lsp].setup {on_attach = on_attach} end

return lsp_config
