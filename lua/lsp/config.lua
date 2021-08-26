local M = {}

-- M.conf_with = function(config)
--   return function(obj)
--     -- TODO: inject flags and on_attach here
--     obj.on_attach = obj.on_attach or config.on_attach or M.common_on_attach
--     obj.filetypes = obj.filetypes or config.filetypes
--     obj.flags = obj.flags or config.flags or O.lsp.flags
--     obj.handlers = {
--       ["textDocument/publishDiagnostics"] = config.diagnostics and vim.lsp.with(
--         vim.lsp.diagnostic.on_publish_diagnostics,
--         config.diagnostics
--       ),
--     }
--   end
-- end
if O.plugin.coq then
  M.coq = require "coq"()
  M.coq_lsp = M.coq.lsp_ensure_capabilities
  M.conf_with = function(config)
    return M.coq_lsp(config)
  end
  M.setup = function(lspconfig)
    return function(obj)
      lspconfig.setup(M.conf_with(obj))
    end
  end
else
  M.conf_with = function(config)
    return config
  end
  M.setup = function(lspconfig)
    return function(obj)
      lspconfig.setup(obj)
    end
  end
end
M.lspconfig = function(name)
  return M.setup(require("lspconfig")[name])
end

return M
