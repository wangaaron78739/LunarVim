if O.plugin.rust_tools then
  require("lv-rust-tools").ftplugin()
else
  ----------------------------------------------------------------------
  --                           UNSUPPORTED                            --
  ----------------------------------------------------------------------
  utils.define_augroups {
    _rust_inlay_hints = {
      {
        "CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost",
        "*",
        [[lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} } ]],
      },
    },
  }

  require("lsp.config").lspconfig "rust_analyzer" {
    cmd = { DATA_PATH .. "/lspinstall/rust/rust-analyzer" },

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
  }
end

-- You should specify your *installed* sources.
-- utils.define_augroups {
--   __crates_toml = {
--     {'FileType', "toml", ""},
--   },
-- }
-- require("cmp").setup.buffer {
--   { name = "luasnip" },
--   { name = "nvim_lsp" },
--   { name = "buffer" },
--   { name = "path" },
--   -- { name = "latex_symbols" },
--   { name = "calc" },
--   -- { name = "cmp_tabnine" },
--   { name = "crates" },
-- }
