CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
PLUGIN_PATH = DATA_PATH .. "site/pack/*/start/*"
TERMINAL = vim.fn.expand "$TERMINAL"
local enable_plugins_by_default = true
local codeLens = {
  virtual_text = { spacing = 0, prefix = "" },
  signs = true,
  underline = true,
  severity_sort = true,
}
local default_diagnostics = {
  virtual_text = { spacing = 0, prefix = "", severity_limit = "Warning" },
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = true,
}
-- TODO: Cleanup this config struct
O = {
  format_on_save = true,
  format_on_save_timeout = 500,
  auto_close_tree = 0,
  fold_columns = "0",
  auto_complete = true,
  colorcolumn = "99999",
  clipboard = "unnamedplus",
  hidden_files = true,
  wrap_lines = false,
  spell = false,
  spelllang = "en",
  number = true,
  relative_number = true,
  number_width = 2,
  shift_width = 4,
  tab_stop = 4,
  cmdheight = 2,
  cursorline = true,
  shell = "bash", -- shell is used for running scripts
  termshell = "fish", -- termshell is used for interactive terminals
  timeoutlen = 300,
  nvim_tree_disable_netrw = 0,
  ignore_case = true,
  smart_case = true,
  scrolloff = 10,
  lushmode = false,
  hl_search = true,
  inc_subs = "split",
  transparent_window = false,
  leader_key = "space",
  local_leader_key = ",",
  vnsip_dir = CONFIG_PATH .. "/snippets",
  notify = {
    timeout = 2000, -- 5000 default
  },
  breakpoint_sign = { text = "🛑", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" },
  lsp = {
    document_highlight = true,
    autoecho_line_diagnostics = false,
    live_codelens = true,
    -- none, single, double, rounded, solid, shadow, array(fullcustom)
    border = "rounded",
    rename_border = "none",
    diagnostics = default_diagnostics,
    codeLens = codeLens,
    flags = {
      debounce_text_changes = 150,
    },
  },
  python_interp = "/usr/bin/python3.9", -- TODO: make a venv for this
  -- @usage pass a table with your desired languages
  treesitter = {
    ensure_installed = "all",
    ignore_install = {},
    active = true,
    enabled = true,
    -- Specify languages that need the normal vim syntax highlighting as well
    -- disable as much as possible for performance
    additional_vim_regex_highlighting = { "latex" },
    -- The below are for treesitter-textobjects plugin
    textobj_prefixes = {
      -- goto_next = "]", -- Go to next
      -- goto_next = "'", -- Go to next
      goto_next = "]", -- Go to next
      goto_previous = "[", -- Go to previous
      -- goto_next = "<leader>n", -- Select next
      -- goto_previous = "<leader>p", -- Select previous
      sel_next = "]", -- Select next
      sel_previous = "[", -- Select previous
      inner = "i", -- Select inside
      outer = "a", -- Selct around
      swap = "<leader>a", -- Swap with next
    },
    textobj_suffixes = {
      -- Start and End respectively for the goto keys
      -- Outer and Inner for the select_{next,prev} keys
      -- for other keys it only uses the first
      ["function"] = { "f", "F" },
      ["class"] = { "m", "M" },
      ["parameter"] = { "a", "A" },
      ["block"] = { "k", "K" },
      ["conditional"] = { "i", "I" },
      ["call"] = { "c", "C" },
      ["loop"] = { "l", "L" },
      ["statement"] = { "s", "S" },
      ["comment"] = { "/", "?" },
    },
    -- The below is for treesitter hint textobjects plugin
    hint_labels = { "a", "s", "d", "f", "h", "j", "k", "l" },
  },
  database = { save_location = "~/.config/nvim/.db", auto_execute = 1 },
  plugin = {
    hop = {},
    twilight = {},
    notify = {},
    dial = {},
    dashboard = {},
    matchup = {},
    colorizer = {},
    numb = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
    zen = {},
    ts_playground = {},
    ts_context_commentstring = {},
    ts_textobjects = {},
    ts_autotag = {},
    ts_textsubjects = {},
    ts_textunits = {},
    ts_rainbow = {},
    ts_context = {},
    ts_hintobjects = {},
    ts_matchup = {},
    indent_line = {},
    symbol_outline = {},
    debug = {},
    bqf = {},
    trouble = {},
    floatterm = {},
    spectre = {},
    project_nvim = {
      -- Manual mode doesn't automatically change your root directory, so you have
      -- the option to manually do so using `:ProjectRoot` command.
      manual_mode = true,
      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = false,
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim
      -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
      -- order matters: if one is not detected, the other is used as fallback. You
      -- can also delete or rearangne the detection methods.
      -- detection_methods = { "lsp", "pattern" },
      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      -- patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      -- ignore_lsp = {},
    },
    markdown_preview = {},
    codi = {},
    telescope_fzy = {},
    telescope_frecency = {},
    telescope_fzf = {},
    sanegx = {},
    ranger = {},
    todo_comments = {},
    lsp_colors = {},
    lsp_signature = {
      doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- Apply indentation for wrapped lines
      use_lspsaga = false, -- set to true if you want to use lspsaga popup
      floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
      fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
      hint_enable = true, -- virtual hint enable
      hint_prefix = "🐼 ", -- Panda for parameter
      max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
      max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
      bind = true,
      handler_opts = { border = "rounded" },
      hint_scheme = "String",
      hi_parameter = "Search",
      toggle_key = "<C-S-space>", -- TODO: Can I add this to C-Space as well?
      zindex = 1,
    },
    git_blame = {},
    gitlinker = {
      opts = {
        -- Manual mode doesn't automatically change your root directory, so you have
        -- the option to manually do so using `:ProjectRoot` command.
        -- manual_mode = false,
        -- When set to false, you will get a message when project.nvim changes your
        -- directory.
        silent_chdir = false,
        -- Methods of detecting the root directory. **"lsp"** uses the native neovim
        -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
        -- order matters: if one is not detected, the other is used as fallback. You
        -- can also delete or rearangne the detection methods.
        -- detection_methods = { "lsp", "pattern" },
        -- All the patterns used to detect root dir, when **"pattern"** is in
        -- detection_methods
        -- patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
        -- Table of lsp clients to ignore by name
        -- eg: { "efm", ... }
        -- ignore_lsp = {},
      },
    },
    lazygit = {},
    octo = {},
    lush = {},
    diffview = {},
    bracey = {},
    telescope_project = {},
    gist = {},
    dap_install = {},
    visual_multi = {},
    lightspeed = {}, -- Uses lightspeed.nvim
    quickscope = {
      -- event = "BufRead"
      -- on_keys = { "f", "F", "t", "T" }, -- Comment this line to have it always visible
    },
    surround = {}, -- Uses vim-sandwhich
    fzf = {},
    slime = { target = "kitty" },
    magma = {},
    neoterm = {
      automap_keys = "xx",
    },
    bullets = {},
    vista = {},
    startuptime = {},
    tabnine = {},
    tmux_navigator = {},
    flutter_tools = {},
    editorconfig = {},
    anywise_reg = {
      operators = { "y", "d" }, -- putting 'c' breaks it (wrong insert mode cursor)
      registers = { "+", "a" },
      textobjects = {
        { "a", "i" }, -- Add 'i' if you want to track inner selections as well
        -- TODO: how to auto get all the textobjects in the world
        { "w", "W", "b", "B", "(", "a", "f", "m", "s", "/", "c" },
      },
      paste_keys = { ["p"] = "p", ["P"] = "P" },
      register_print_cmd = false,
    },
    doge = {},
    undotree = {},
    ts_iswap = { autoswap = true },
    coq = {},
    cmp = {
      lspkind = {
        with_text = true,
        -- symbol_map = {
        --   Text = "",
        --   Method = "",
        --   Function = "",
        --   Constructor = "",
        --   Field = "ﰠ",
        --   Variable = "",
        --   Class = "ﴯ",
        --   Interface = "",
        --   Module = "",
        --   Property = "ﰠ",
        --   Unit = "塞",
        --   Value = "",
        --   Enum = "",
        --   Keyword = "",
        --   Snippet = "",
        --   Color = "",
        --   File = "",
        --   Reference = "",
        --   Folder = "",
        --   EnumMember = "",
        --   Constant = "",
        --   Struct = "פּ",
        --   Event = "",
        --   Operator = "",
        --   TypeParameter = "",
        -- },
      },
    },
    luasnip = {},
    primeagen_refactoring = {},
  },
  lang = {
    python = {
      isort = false,
      analysis = {
        type_checking = "basic", -- off
        auto_search_paths = true,
        use_library_code_types = true,
      },
      formatter = "black",
    },
    dart = { sdk_path = "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot" },
    lua = {},
    sh = {},
    tsserver = {
      linter = "eslint",
      formatter = "prettier",
    },
    json = {},
    tailwindcss = {
      active = false,
      filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      },
    },
    -- Used for js, ts, jsreact and tsreact -- I assume they are all similar enough
    javascript = {},
    clang = {
      cross_file_rename = true,
      header_insertion = "never",
    },
    ruby = { filetypes = { "rb", "erb", "rakefile", "ruby" } },
    go = {},
    elixir = {},
    vim = {},
    yaml = {},
    terraform = {},
    rust = {
      rust_tools = { active = true },
      linter = "",
    },
    svelte = {},
    php = {
      format = { braces = "psr12" },
      environment = { php_version = "7.4" },
      filetypes = { "php", "phtml" },
    },
    latex = {
      vimtex = { active = true },
      filetypes = { "tex", "bib" },
      texlab = {
        aux_directory = ".",
        bibtex_formatter = "texlab",
        build = {
          -- TODO: Use tectonic here
          executable = "tectonic",
          args = {
            -- Input
            "%f",
            -- Flags
            "--synctex",
            "--keep-logs",
            "--keep-intermediates",
            -- Options
            -- OPTIONAL: If you want a custom out directory,
            -- uncomment the following line.
            --"--outdir out",
          },
          forwardSearchAfter = false,
          onSave = true,
        },
        chktex = { on_edit = true, on_open_and_save = true },
        diagnostics_delay = vim.opt.updatetime,
        formatter_line_length = 80,
        forward_search = { args = {}, executable = "" },
        latexFormatter = "latexindent",
        latexindent = { modify_line_breaks = false },
      },
    },
    kotlin = {},
    html = {},
    elm = {},
    emmet = { active = false },
    graphql = {},
    docker = {},
    cmake = {},
    java = {},
    zig = {},
    julia = {},
  },
  dashboard = {
    footer = { "Anshuman Medhi -- IndianBoy42 (amedhi@connect.ust.hk)" },
  },
}
vim.cmd('let &titleold="' .. TERMINAL .. '"')
-- After changing plugin config it is recommended to run :PackerCompile
local disable_plugins = {
  "fzf",
  "tabnine",
  "tmux_navigator",
  "lazygit",
  "anywise_reg",
  "quickscope",
  "bullets",
  "coq",
  "primeagen_refactoring",
}
for _, v in ipairs(disable_plugins) do
  O.plugin[v] = false
end
require("lv-utils").set_guifont(11)
