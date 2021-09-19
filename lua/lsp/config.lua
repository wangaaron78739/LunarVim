local M = {}
local lsp_status = require "lsp-status"

local function diags(conf)
  return conf and conf.diagnostics and vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, conf.diagnostics)
end
local common_on_attach = require("lsp.functions").common_on_attach
local inject_conf = function(obj)
  obj.on_attach = obj.on_attach or common_on_attach
  obj.flags = obj.flags or O.lsp.flags

  if obj.handlers == nil then
    if obj.diagnostics then
      obj.handlers = { ["textDocument/publishDiagnostics"] = diags(obj.diagnostics) }
    end
  else
    obj.handlers["textDocument/publishDiagnostics"] = diags(obj.diagnostics)
  end
  return obj
end
M.inject = inject_conf

----------------------------------------------------------------------
--              coq_nvim for completions and snippets               --
----------------------------------------------------------------------
if O.plugin.coq then
  M.coq = require "coq"()
  M.coq_lsp = M.coq.lsp_ensure_capabilities
  M.conf_with = function(config)
    config.capabilities = M.caps(config.capabilities)
    return M.coq_lsp(config)
  end
else
  ----------------------------------------------------------------------
  --                       nvim-cmp + luasnips                        --
  ----------------------------------------------------------------------
  M.conf_with = function(config)
    -- Set default client capabilities plus window/workDoneProgress
    config.capabilities = M.caps(config.capabilities)
    config.capabilities = require("cmp_nvim_lsp").update_capabilities(config.capabilities)
    return config
  end
end

M.setup = function(lspconfig)
  return function(obj)
    lspconfig.setup(M.conf_with(inject_conf(obj)))
  end
end

M.caps = function(overrides)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  overrides = vim.tbl_extend("error", overrides or {}, lsp_status.capabilities)
  return vim.tbl_deep_extend("keep", overrides, capabilities)
end

local function nop() end
M.lspconfig = function(name)
  -- Check if client is already active/config
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return nop
    end
  end

  return M.setup(require("lspconfig")[name])
end

return M
