local efm = {}

function efm.generic_setup(ft)
  if not require("lv-utils").check_lsp_client_active "efm" then
    if O.lang[ft].efm.active == true then
      require("lspconfig").efm.setup {
        cmd = {
          DATA_PATH .. "/lspinstall/efm/efm-langserver",
          "-c",
          O.efm.config_path,
        },
        init_options = { documentFormatting = true, codeAction = false, completion = false, documentSymbol = false },
        filetypes = ft,
        -- rootMarkers = {".git/", "package.json"},
      }
    end
  end
end

return efm
