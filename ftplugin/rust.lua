if require("lv-utils").check_lsp_client_active "rust_analyzer" then
  return
end

if O.lang.rust.rust_tools.active then
  local opts = {
    tools = { -- rust-tools options
      inlay_hints = {
        -- only_current_line = true,

        -- prefix for parameter hints
        -- default: "<-"
        parameter_hints_prefix = "<= ",

        -- prefix for all the other hints (type, chaining)
        -- default: "=>"
        other_hints_prefix = "=> ",
      },

      hover_actions = {
        -- the border that is used for the hover window
        -- see vim.api.nvim_open_win()
        border = O.lsp.border,
        -- border = {
        --   { "╭", "FloatBorder" },
        --   { "─", "FloatBorder" },
        --   { "╮", "FloatBorder" },
        --   { "│", "FloatBorder" },
        --   { "╯", "FloatBorder" },
        --   { "─", "FloatBorder" },
        --   { "╰", "FloatBorder" },
        --   { "│", "FloatBorder" },
        -- },
      },
      autofocus = true,
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
      cmd = { DATA_PATH .. "/lspinstall/rust/rust-analyzer" },
      on_attach = require("lsp.functions").common_on_attach,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            enable = true,
            command = "clippy", -- comment out to not use clippy
          },
        },
      },
    }, -- rust-analyser options
  }
  require("rust-tools").setup(opts)

  local map = vim.api.nvim_buf_set_keymap
  -- map("n", "gj", "<cmd>RustJoinLines<cr>", {})
  vim.cmd [[ autocmd FileType rust nmap gj <cmd>RustJoinLines<cr>]]
else
  vim.cmd [[ autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} } ]]

  require("lspconfig").rust_analyzer.setup {
    cmd = { DATA_PATH .. "/lspinstall/rust/rust-analyzer" },
    on_attach = require("lsp.functions").common_on_attach,
    filetypes = { "rust" },
    root_dir = require("lspconfig.util").root_pattern("Cargo.toml", "rust-project.json"),
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_self",
        },
        cargo = { loadOutDirsFromCheck = true },
        procMacro = { enable = true },
        checkOnSave = {
          enable = true,
          command = "clippy", -- comment out to not use clippy
        },
      },
    },
    flags = O.lsp.flags,
  }
end

-- TODO fix these mappings
vim.api.nvim_exec(
  [[
    autocmd Filetype rust nnoremap <leader>lm <Cmd>RustExpandMacro<CR>
    autocmd Filetype rust nnoremap <leader>lH <Cmd>RustToggleInlayHints<CR>
    autocmd Filetype rust nnoremap <leader>le <Cmd>RustRunnables<CR>
    autocmd Filetype rust nnoremap <leader>lh <Cmd>RustHoverActions<CR>
    ]],
  true
)

if O.lang.rust.autoformat then
  require("lv-utils").define_augroups {
    _rust_format = {
      { "BufWritePre", "*.rs", "lua vim.lsp.buf.formatting_sync(nil,1000)" },
    },
  }
end
