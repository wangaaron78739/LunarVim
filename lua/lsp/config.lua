local M = {}

local function diags(conf)
  return conf and conf.diagnostics and vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, conf.diagnostics)
end
local common_on_attach = require("lsp.functions").common_on_attach
local function inject_conf(obj)
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

  -- if obj.handlers == nil then
  --   if obj.diagnostics then
  --     obj.handlers = { ["textDocument/publishDiagnostics"] = diags(obj.diagnostics) }
  --   end
  -- else
  --   obj.handlers["textDocument/publishDiagnostics"] = diags(obj.diagnostics)
  -- end

  return obj
end
M.inject = inject_conf

local lsp_installer_exists, lsp_installer = pcall(require, "nvim-lsp-installer")

----------------------------------------------------------------------
--              coq_nvim for completions and snippets               --
----------------------------------------------------------------------
if O.plugin.coq then
  M.coq = require "coq"()
  M.coq_lsp = M.coq.lsp_ensure_capabilities
  function M.conf_with(config)
    config = inject_conf(config)
    config.capabilities = M.caps(config.capabilities)
    return M.coq_lsp(config)
  end
else
  ----------------------------------------------------------------------
  --                       nvim-cmp + luasnips                        --
  ----------------------------------------------------------------------
  function M.conf_with(config)
    config = inject_conf(config)
    -- Set default client capabilities plus window/workDoneProgress
    config.capabilities = M.caps(config.capabilities)
    config.capabilities = require("cmp_nvim_lsp").update_capabilities(config.capabilities)
    return config
  end
end

local function lsp_attach_buffers()
  vim.cmd [[do User LspAttachBuffers]]
end

function M.get_cmd(name, extra_cmd_args)
  if lsp_installer_exists then
    local ok, server = require("nvim-lsp-installer.servers").get_server(name)
    local installopts = server:get_default_options()
    local cmd = installopts.cmd
    if extra_cmd_args then
      vim.list_extend(cmd, extra_cmd_args)
    end
    return cmd
  end
end
function M.get_cmd_env(name, extra_cmd_args)
  if lsp_installer_exists then
    local ok, server = require("nvim-lsp-installer.servers").get_server(name)
    local installopts = server:get_default_options()
    return installopts.cmd_env
  end
end

function M.setup(lspconfig, name)
  if lsp_installer_exists then
    local ok, server = require("nvim-lsp-installer.servers").get_server(name)
    local process = require "nvim-lsp-installer.process"
    local function setup(obj)
      local installopts = server:get_default_options()
      local opts = M.conf_with(obj)
      opts.cmd = installopts.cmd
      if opts.extra_cmd_args then
        vim.list_extend(opts.cmd, opts.extra_cmd_args)
      end
      server:setup(opts)
      lsp_attach_buffers()
    end

    if ok then
      if server:is_installed() then
        return setup
      else
        return function(obj)
          server:install_attached({
            -- You can choose which one you prefer. You can also provide your own "sink" implementation (see impl. for reference)
            stdio_sink = process.simple_sink(), -- will print stdout and stderr to message-history
            requested_server_version = "nightly", -- optional, but you may also provide a version you want to install
          }, function(success)
            if success then
              setup(obj)
            end
          end)
        end
      end
    end
  else
    return function(obj)
      lspconfig.setup(M.conf_with(obj))
      lsp_attach_buffers()
    end
  end
end

function M.caps(overrides)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local lsp_status = require "lsp-status"
  overrides = vim.tbl_deep_extend("keep", overrides or {}, lsp_status.capabilities)
  return vim.tbl_deep_extend("keep", overrides, capabilities)
end

local function nop() end
function M.lspconfig(name)
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
