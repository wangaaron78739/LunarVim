local M = {}
local nore = require("keymappings").nore
function M.ftplugin()
  mappings.localleader {
    m = { "<Cmd>RustExpandMacro<CR>", "Expand Macro" },
    H = { "<Cmd>RustToggleInlayHints<CR>", "Toggle Inlay Hints" },
    e = { "<Cmd>RustRunnables<CR>", "Runnables" },
    h = { "<Cmd>RustHoverActions<CR>", "Hover Actions" },
    s = { ":RustSSR ", "Structural S&R" },
  }
  nore("x", "gh", "<cmd>RustHoverRange<CR>", { buffer = true })
  nore("n", "gh", "<cmd>RustHoverActions<CR>", { buffer = true })
  nore("n", "gj", "<cmd>RustJoinLines<CR>", { buffer = true })
  nore("n", "K", "<cmd>RustCodeAction<CR>", { buffer = true })
  -- nore("x", "K", "<esc><cmd>'<,'>lua vim.lsp.buf.range_code_action()<cr>", { buffer = true })
  mappings.ftleader {
    pR = { "<CMD>RustRunnables<CR>", "Rust Run" },
    pd = { "<CMD>RustDebuggables<CR>", "Rust Debug" },
  }

  -- require("lv-utils").define_augroups {
  --   _rust_hover_range = {
  --     { "CursorHold, CursorHoldI", "<buffer>", "RustHoverActions" },
  --   },
  -- }
end
function M.setup()
  local function postfix_wrap_call(trig, call, requires)
    return {
      postfix = trig,
      body = {
        call .. "(${receiver})",
      },
      requires = requires,
      scope = "expr",
    }
  end
  local snippets = {
    ["Arc::new"] = postfix_wrap_call("arc", "Arc::new", "std::sync::Arc"),
    ["Mutex::new"] = postfix_wrap_call("mutex", "Mutex::new", "std::sync::Mutex"),
    ["RefCell::new"] = postfix_wrap_call("refcell", "RefCell::new", "std::cell::RefCell"),
    ["Cell::new"] = postfix_wrap_call("cell", "Cell::new", "std::cell::Cell"),
    ["Rc::new"] = postfix_wrap_call("rc", "Rc::new", "std::rc::Rc"),
    ["Box::pin"] = postfix_wrap_call("pin", "Box::pin"),
    ["unsafe"] = {
      postfix = "unsafe",
      body = { "unsafe { ${receiver} }" },
      description = "Wrap in unsafe{}",
      scope = "expr",
    },
    ["thread::spawn"] = {
      prefix = "spawn",
      body = {
        "thread::spawn(move || {",
        "\t$0",
        "});",
      },
      description = "Spawn a new thread",
      requires = "std::thread",
      scope = "expr",
    },
    ["channel"] = {
      prefix = "channel",
      body = { "let (tx,rx) = mpsc::channel()" },
      description = "(tx,rx) = channel()",
      requires = "std::sync::mpsc",
      scope = "expr",
    },
  }
  local opts = {
    tools = { -- rust-tools options
      inlay_hints = {
        -- only_current_line = true,

        -- prefix for parameter hints
        -- default: "<-"
        -- parameter_hints_prefix = "❰❰ ",
        parameter_hints_prefix = "« ",

        -- prefix for all the other hints (type, chaining)
        -- default: "=>"
        other_hints_prefix = "∈ ",
        -- other_hints_prefix = ":: ",
      },

      runnables = {
        use_telescope = true,
        layout_config = {
          width = 0.4,
          height = 0.4,
        },
      },
      debuggables = {
        use_telescope = true,
        layout_config = {
          width = 0.4,
          height = 0.4,
        },
      },

      hover_actions = {
        -- the border that is used for the hover window
        -- see vim.api.nvim_open_win()
        border = O.lsp.border,
        auto_focus = true,
      },

      -- dap = function()
      --   -- Update this path
      --   local extension_path = "/home/amedhi/.vscode/extensions/vadimcn.vscode-lldb-1.6.7/"
      --   local codelldb_path = extension_path .. "adapter/codelldb"
      --   local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      --   return {
      --     adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      --   }
      -- end,
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = require("lsp.config").conf_with {
      cmd = require("lsp.config").get_cmd "rust_analyzer",
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            enable = true,
            command = "clippy", -- comment out to not use clippy
          },
          completion = {
            snippets = snippets,
          },
        },
      },
    }, -- rust-analyser options
  }

  require("rust-tools").setup(opts)
end

function M.crates_ftplugin()
  require("lv-cmp").add_sources { { name = "crates" } }
  local prefix = "<cmd>lua require'crates'."
  mappings.localleader {
    t = { prefix .. "toggle()<cr>", "Toggle" },
    r = { prefix .. "reload()<cr>", "Reload" },
    u = { prefix .. "update_crate()<cr>", "Update Crate" },
    a = { prefix .. "update_all_crates()<cr>", "Update All" },
    U = { prefix .. "upgrade_crate()<cr>", "Upgrade Crate" },
    A = { prefix .. "upgrade_all_crates()<cr>", "Upgrade All" },
    ["<localleader>"] = { prefix .. "show_versions_popup()<cr>", "Versions" },
  }
  mappings.vlocalleader {
    u = { ":lua require('crates').update_crates()<cr>", "Update" },
    U = { ":lua require('crates').upgrade_crates()<cr>", "Upgrade" },
  }
end
function M.crates_setup()
  -- vim.cmd [[autocmd FileType toml lua require("lv-cmp").add_sources { { name = "crates" } }]]
  vim.cmd [[autocmd BufRead Cargo.toml lua require("lv-rust-tools").crates_ftplugin()]]
end
return M
