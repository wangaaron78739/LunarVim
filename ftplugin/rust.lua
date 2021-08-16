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
      },
      autofocus = true,
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = require("lsp.functions").coq_lsp {
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

  -- -- TODO fix these mappings
  noremap("n", "<leader>lm", "<Cmd>RustExpandMacro<CR>", { buffer = true })
  noremap("n", "<leader>lH", "<Cmd>RustToggleInlayHints<CR>", { buffer = true })
  noremap("n", "<leader>le", "<Cmd>RustRunnables<CR>", { buffer = true })
  noremap("n", "<leader>lh", "<Cmd>RustHoverActions<CR>", { buffer = true })
  noremap("v", "<leader>lh", "<Cmd>RustHoverRange<CR>", { buffer = true })
  noremap("v", "gh", "<cmd>RustHoverRange<CR>", { buffer = true })
  noremap("n", "gj", "<cmd>RustJoinLines<CR>", { buffer = true })

  -- require("lv-utils").define_augroups {
  --   _rust_hover_range = {
  --     { "CursorHold, CursorHoldI", "<buffer>", "RustHoverActions" },
  --   },
  -- }
else
  vim.cmd [[ autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} } ]]

  require("lsp.functions").lspconfig "rust_analyzer" {
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

if O.lang.rust.autoformat then
  require("lv-utils").define_augroups {
    _rust_format = {
      { "BufWritePre", "*.rs", "lua vim.lsp.buf.formatting_sync(nil,1000)" },
    },
  }
end
