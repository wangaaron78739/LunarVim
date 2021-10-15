local M = {}

local function diags(conf)
  return conf and conf.diagnostics and vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, conf.diagnostics)
end
local common_on_attach = require("lsp.functions").common_on_attach
local inject_conf = function(obj)
  local custom_on_attach = obj.on_attach
  if custom_on_attach then
    obj.on_attach = function(client, _bufnr)
      common_on_attach(client, _bufnr)
      custom_on_attach(client, _bufnr)
    end
  else
    obj.on_attach = common_on_attach
  end
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
    config = inject_conf(config)
    config.capabilities = M.caps(config.capabilities)
    return M.coq_lsp(config)
  end
else
  ----------------------------------------------------------------------
  --                       nvim-cmp + luasnips                        --
  ----------------------------------------------------------------------
  M.conf_with = function(config)
    config = inject_conf(config)
    -- Set default client capabilities plus window/workDoneProgress
    config.capabilities = M.caps(config.capabilities)
    config.capabilities = require("cmp_nvim_lsp").update_capabilities(config.capabilities)
    return config
  end
end

local lsp_installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if lsp_installer_ok then
  M.try_install = function(name)
    local ok, server = require("nvim-lsp-installer.servers").get_server(name)
    if ok then
      if not server:is_installed() then
        server:install()
        return true
      end
    end

    return true
  end
else
  M.try_install = function()
    print "do :LspInstall manually"
    return false
  end
end

M.setup = function(lspconfig, name)
  if M.try_install(name) and true then
    return function(obj)
      local ok, server = require("nvim-lsp-installer.servers").get_server(name)
      if ok and server:is_installed() then
        local installopts = server:get_default_options()
        local opts = M.conf_with(obj)
        opts.cmd = installopts.cmd
        if opts.extra_cmd_args then
          vim.list_extend(opts.cmd, opts.extra_cmd_args)
        end
        server:setup(opts)
      end
    end
  else
    return function(obj)
      lspconfig.setup(M.conf_with(obj))
    end
  end
end

M.caps = function(overrides)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local lsp_status = require "lsp-status"
  overrides = vim.tbl_deep_extend("keep", overrides or {}, lsp_status.capabilities)
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

  return M.setup(require("lspconfig")[name], name)
end

return M
