-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
local sumneko_root_path = DATA_PATH .. "/lspinstall/lua"
local sumneko_binary = sumneko_root_path .. "/sumneko-lua-language-server"

require("lsp.config").lspconfig "sumneko_lua" {
  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "O" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 1000,
      },
    },
  },
}

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

-- mappings.buf(0, "x", "is", "?[[<cr>o/]]<cr>", {})
require("lv-sandwich").add_recipe {
  buns = { "[[", "]]" },
  quoteescape = true,
  expand_range = false,
  nesting = false,
  input = { "s" },
}

require("lv-cmp").add_sources { { name = "nvim_lua" } }
