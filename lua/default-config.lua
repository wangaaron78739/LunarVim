CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
PLUGIN_PATH = DATA_PATH .. "site/pack/*/start/*"
TERMINAL = vim.fn.expand "$TERMINAL"

local enable_plugins_by_default = true
-- TODO: switch between neoformat and lsp autoformat smartly

local codeLens = {
  virtual_text = { spacing = 0, prefix = "" },
  signs = true,
  underline = true,
  severity_sort = true,
}
local diagnostics = {
  virtual_text = { spacing = 0, prefix = "", severity_limit = "Warning" },
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = true,
}

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
  shell = "bash",
  termshell = "bash",
  timeoutlen = 300,
  nvim_tree_disable_netrw = 0,
  ignore_case = true,
  smart_case = true,
  scrolloff = 0,
  lushmode = false,
  hl_search = false,
  inc_subs = "split",
  transparent_window = false,
  document_highlight = true,
  autoecho_line_diagnostics = false,
  leader_key = "space",
  localleader_key = ",",
  vnsip_dir = CONFIG_PATH .. "/snippets",
  breakpoint_sign = { text = "🛑", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" },
  lsp = {
    -- none, single, double, rounded, solid, shadow, array(fullcustom)
    border = "rounded",
    rename_border = "none",
    diagnostics = diagnostics,
    codeLens = codeLens,
    flags = {
      debounce_text_changes = 150,
    },
  },
  python_interp = "/usr/bin/python3.9", -- TODO: make a venv for this
  -- @usage pass a table with your desired languages
  treesitter = {
    ensure_installed = "all",
    ignore_install = { "haskell" },
    active = true,
    -- Specify languages that need the normal vim syntax highlighting as well
    -- disable as much as possible for performance
    additional_vim_regex_highlighting = { "latex" },
    -- The below are for treesitter-textobjects plugin
    textobj_prefixes = {
      -- goto_next = "]", -- Go to next
      -- goto_next = "'", -- Go to next
      goto_next = "&", -- Go to next
      goto_previous = "[", -- Go to previous
      inner = "i", -- Select inside
      outer = "a", -- Selct around
      swap = "<leader>a", -- Swap with next
    },
    textobj_suffixes = {
      -- Start and End respectively for the goto keys
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
    hint_labels = { "h", "j", "f", "d", "n", "v", "s", "l", "a" },
  },
  database = { save_location = "~/.config/nvim/.db", auto_execute = 1 },
  plugin_which_keys = {},
  plugin = {
    hop = { active = enable_plugins_by_default },
    dial = { active = enable_plugins_by_default },
    dashboard = { active = enable_plugins_by_default },
    matchup = { active = enable_plugins_by_default },
    colorizer = { active = enable_plugins_by_default },
    numb = { active = enable_plugins_by_default },
    zen = { active = enable_plugins_by_default },
    ts_playground = { active = enable_plugins_by_default },
    ts_context_commentstring = { active = enable_plugins_by_default },
    ts_textobjects = { active = enable_plugins_by_default },
    ts_autotag = { active = enable_plugins_by_default },
    ts_textsubjects = { active = enable_plugins_by_default },
    ts_rainbow = { active = enable_plugins_by_default },
    ts_context = { active = enable_plugins_by_default },
    ts_hintobjects = { active = enable_plugins_by_default },
    ts_matchup = { active = enable_plugins_by_default },
    indent_line = { active = enable_plugins_by_default },
    symbol_outline = { active = enable_plugins_by_default },
    debug = { active = enable_plugins_by_default },
    bqf = { active = enable_plugins_by_default },
    trouble = { active = enable_plugins_by_default },
    floatterm = { active = enable_plugins_by_default },
    spectre = { active = enable_plugins_by_default },
    project_nvim = { active = enable_plugins_by_default },
    markdown_preview = { active = enable_plugins_by_default },
    codi = { active = enable_plugins_by_default },
    telescope_fzy = { active = enable_plugins_by_default },
    sanegx = { active = enable_plugins_by_default },
    snap = { active = enable_plugins_by_default },
    ranger = { active = enable_plugins_by_default },
    todo_comments = { active = enable_plugins_by_default },
    lsp_colors = { active = enable_plugins_by_default },
    lsp_signature = {
      active = enable_plugins_by_default,
      doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- Apply indentation for wrapped lines
      use_lspsaga = false, -- set to true if you want to use lspsaga popup
      floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
      fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
      hint_enable = true, -- virtual hint enable
      hint_prefix = "🐼 ", -- Panda for parameter
      max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
      max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    },
    git_blame = { active = enable_plugins_by_default },
    gitlinker = { active = enable_plugins_by_default },
    lazygit = { active = enable_plugins_by_default },
    octo = { active = enable_plugins_by_default },
    lush = { active = enable_plugins_by_default },
    diffview = { active = enable_plugins_by_default },
    bracey = { active = enable_plugins_by_default },
    telescope_project = { active = enable_plugins_by_default },
    gist = { active = enable_plugins_by_default },
    dap_install = { active = enable_plugins_by_default },
    visual_multi = { active = enable_plugins_by_default },
    lightspeed = { active = enable_plugins_by_default }, -- Uses lightspeed.nvim
    quickscope = {
      active = enable_plugins_by_default,
      -- event = "BufRead"
      -- on_keys = { "f", "F", "t", "T" }, -- Comment this line to have it always visible
    },
    surround = { active = enable_plugins_by_default }, -- Uses vim-sandwhich
    fzf = { active = enable_plugins_by_default },
    slime = { active = enable_plugins_by_default, target = "kitty" },
    magma = { active = enable_plugins_by_default },
    bullets = { active = enable_plugins_by_default },
    vista = { active = enable_plugins_by_default },
    startuptime = { active = enable_plugins_by_default },
    tabnine = { active = enable_plugins_by_default },
    tmux_navigator = { active = enable_plugins_by_default },
    flutter_tools = { active = enable_plugins_by_default },
    editorconfig = { active = enable_plugins_by_default },
    anywise_reg = { active = enable_plugins_by_default },
    doge = { active = enable_plugins_by_default },
    undotree = { active = enable_plugins_by_default },
    ts_iswap = { active = enable_plugins_by_default },
  },
  custom_plugins = {},
  lang = {
    python = {
      isort = false,
      diagnostics = diagnostics,
      analysis = {
        type_checking = "basic",
        auto_search_paths = true,
        use_library_code_types = true,
      },
    },
    dart = {
      sdk_path = "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot",
    },
    lua = {
      diagnostics = diagnostics,
    },
    sh = {
      diagnostics = diagnostics,
    },
    tsserver = {
      diagnostics = diagnostics,
    },
    json = {
      diagnostics = diagnostics,
    },
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
    javascript = {
      diagnostics = diagnostics,
    },
    clang = {
      diagnostics = diagnostics,
      cross_file_rename = true,
      header_insertion = "never",
    },
    ruby = {
      diagnostics = diagnostics,
      filetypes = { "rb", "erb", "rakefile", "ruby" },
    },
    go = {
      diagnostics = diagnostics,
    },
    elixir = {
      diagnostics = diagnostics,
    },
    vim = {
      diagnostics = diagnostics,
    },
    yaml = {
      diagnostics = diagnostics,
    },
    terraform = {
      diagnostics = diagnostics,
    },
    rust = {
      rust_tools = { active = false },
      linter = "",
      diagnostics = diagnostics,
    },
    svelte = {
      diagnostics = diagnostics,
    },
    php = {
      diagnostics = diagnostics,
      format = { braces = "psr12" },
      environment = { php_version = "7.4" },
      filetypes = { "php", "phtml" },
    },
    latex = {
      vimtex = { active = true },
      diagnostics = diagnostics,
      filetypes = { "tex", "bib" },
      aux_directory = ".",
      bibtex_formatter = "texlab",
      build = {
        -- TODO: Use tectonic here
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        executable = "latexmk",
        forward_search_after = false,
        on_save = false,
      },
      chktex = { on_edit = false, on_open_and_save = false },
      diagnostics_delay = vim.opt.updatetime,
      formatter_line_length = 80,
      forward_search = { args = {}, executable = "" },
      latex_formatter = "latexindent",
      latexindent = { modify_line_breaks = false },
    },
    kotlin = {
      diagnostics = diagnostics,
    },
    html = {
      diagnostics = diagnostics,
    },
    elm = {
      diagnostics = diagnostics,
    },
    emmet = {
      diagnostics = diagnostics,
      active = false,
    },
    graphql = {
      diagnostics = diagnostics,
    },
    docker = {
      diagnostics = diagnostics,
    },
    cmake = {
      diagnostics = diagnostics,
    },
    java = {
      diagnostics = diagnostics,
    },
    zig = {
      diagnostics = diagnostics,
    },
    julia = {
      diagnostics = diagnostics,
    },
  },
  dashboard = {
    custom_header = {
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣾⠿⠿⠟⠛⠛⠛⠛⠿⠿⣿⣷⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⡿⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⡿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠒⠂⠉⠉⠉⠉⢩⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠸⡀⠀⠀⠀⠀⠀⢰⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⡀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡧⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠈⠁⠒⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠉⠢⠤⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡟⠈⠑⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠒⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⠀⢀⣣⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠒⠢⠤⠄⣀⣀⠀⠀⠀⢠⣿⡟⠀⠀⠀⣺⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
      "⠀⣿⠇⠀⠀⠀⠀⠀⣤⡄⠀⠀⢠⣤⡄⠀⢨⣭⣠⣤⣤⣤⡀⠀⠀⢀⣤⣤⣤⣤⡄⠀⠀⠀⣤⣄⣤⣤⣤⠀⠀⣿⣯⠉⠉⣿⡟⠀⠈⢩⣭⣤⣤⠀⠀⠀⠀⣠⣤⣤⣤⣄⣤⣤",
      "⢠⣿⠀⠀⠀⠀⠀⠀⣿⠃⠀⠀⣸⣿⠁⠀⣿⣿⠉⠀⠈⣿⡇⠀⠀⠛⠋⠀⠀⢹⣿⠀⠀⠀⣿⠏⠀⠸⠿⠃⠀⣿⣿⠀⣰⡟⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣿⡟⢸⣿⡇⢀⣿",
      "⣸⡇⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⣿⡟⠀⢠⣿⡇⠀⠀⢰⣿⡇⠀⣰⣾⠟⠛⠛⣻⡇⠀⠀⢸⡿⠀⠀⠀⠀⠀⠀⢻⣿⢰⣿⠀⠀⠀⠀⠀⠀⣾⡇⠀⠀⠀⢸⣿⠇⢸⣿⠀⢸⡏",
      "⣿⣧⣤⣤⣤⡄⠀⠘⣿⣤⣤⡤⣿⠇⠀⢸⣿⠁⠀⠀⣼⣿⠀⠀⢿⣿⣤⣤⠔⣿⠃⠀⠀⣾⡇⠀⠀⠀⠀⠀⠀⢸⣿⣿⠋⠀⠀⠀⢠⣤⣤⣿⣥⣤⡄⠀⣼⣿⠀⣸⡏⠀⣿⠃",
      "⠉⠉⠉⠉⠉⠁⠀⠀⠈⠉⠉⠀⠉⠀⠀⠈⠉⠀⠀⠀⠉⠉⠀⠀⠀⠉⠉⠁⠈⠉⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠁⠀⠉⠁⠀⠉⠁⠀⠉⠀",
    },
    footer = { "IndianBoy42 (amedhi@connect.ust.hk)" },
  },
}

vim.cmd('let &titleold="' .. TERMINAL .. '"')
