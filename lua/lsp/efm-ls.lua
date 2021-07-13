local efm = {}

function efm.generic_setup(ft)
  if not require("lv-utils").check_lsp_client_active "efm" then
    -- Check should activate
    -- local continue = false
    -- for _, v in ipairs(ft) do
    --   if O.lang[ft].efm.active == true then
    --     continue = true
    --   end
    -- end
    -- if not continue then
    --   return
    -- end

    -- if O.lang[ft].efm.active == true then
    require("lspconfig").efm.setup {
      cmd = {
        DATA_PATH .. "/lspinstall/efm/efm-langserver",
        "-c",
        O.efm.config_path,
      },
      init_options = { documentFormatting = true, codeAction = false, completion = false, documentSymbol = false },
      filetypes = ft,
      -- rootMarkers = {".git/", "package.json"},
      flags = O.lsp.flags,
    }
    -- end
  end
end

return efm
