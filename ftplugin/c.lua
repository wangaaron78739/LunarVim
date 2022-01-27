local lsp_status = require "lsp-status"
vim.opt_local.commentstring = [[// %s]]

local lspconfig = require "lspconfig"
local lsputil = lspconfig.util

local function switch_source_header_splitcmd(bufnr, splitcmd)
  bufnr = lsputil.validate_bufnr(bufnr)
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  vim.lsp.buf_request(
    bufnr,
    "textDocument/switchSourceHeader",
    params,
    lsputil.compat_handler(function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print "Corresponding file can’t be determined"
        return
      end
      vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
    end)
  )
end

local clangd_flags = { "--background-index", "--query-driver=**/arm-none-eabi-*,**/x86_64-linux-*" }
table.insert(clangd_flags, "--cross-file-rename")
table.insert(clangd_flags, "--header-insertion=never")

require("lsp.config").lspconfig "clangd" {
  extra_cmd_args = clangd_flags,
  commands = {
    ClangdSwitchSourceHeader = {
      function()
        switch_source_header_splitcmd(0, "edit")
      end,
      description = "Open source/header in current buffer",
    },
    ClangdSwitchSourceHeaderVSplit = {
      function()
        switch_source_header_splitcmd(0, "vsplit")
      end,
      description = "Open source/header in a new vsplit",
    },
    ClangdSwitchSourceHeaderSplit = {
      function()
        switch_source_header_splitcmd(0, "split")
      end,
      description = "Open source/header in a new split",
    },
  },

  init_options = { clangdFileStatus = true },
  handlers = lsp_status.extensions.clangd.setup(),
}
