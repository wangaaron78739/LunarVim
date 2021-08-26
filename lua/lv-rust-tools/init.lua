local M = {}
function M.ftplugin()
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
end
function M.setup()
  local opts = {
    tools = { -- rust-tools options
      inlay_hints = {
        -- only_current_line = true,

        -- prefix for parameter hints
        -- default: "<-"
        parameter_hints_prefix = "❰❰ ",

        -- prefix for all the other hints (type, chaining)
        -- default: "=>"
        other_hints_prefix = ":: ",
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
    server = require("lsp.config").conf_with {
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
end
return M
