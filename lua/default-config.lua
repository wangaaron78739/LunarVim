CONFIG_PATH = vim.fn.stdpath "config"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
PLUGIN_PATH = DATA_PATH .. "site/pack/*/start/*"
TERMINAL = vim.fn.expand "$TERMINAL"

local enable_plugins_by_default = true
local enable_efm_by_default = false
-- TODO: switch between neoformat and lsp autoformat smartly

local EFM_CONF_PATH = os.getenv "HOME" .. "/.config/efm-langserver/config.yaml"

if vim.fn.empty(vim.fn.glob(EFM_CONF_PATH)) > 0 then
  EFM_CONF_PATH = CONFIG_PATH .. "/utils/efm-config.yaml"
end

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
}
local lsp_border = "single"

O = {
  format_on_save = true,
  auto_close_tree = 0,
  fold_columns = "0",
  auto_complete = true,
  colorscheme = "lunar",
  colorcolumn = "99999",
  clipboard = "unnamedplus",
  hidden_files = true,
  wrap_lines = false,
  spell = false,
  spelllang = "en",
  number = true,
  relative_number = true,
  number_width = 4,
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
  transparent_window = false,
  document_highlight = true,
  leader_key = "space",
  vnsip_dir = CONFIG_PATH .. "/snippets",
  breakpoint_sign = { text = "🛑", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" },
  lsp = {
    border = lsp_border,
    diagnostics = diagnostics,
    codeLens = codeLens,
    flags = {
      debounce_text_changes = 150,
    },
  },
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
      goto_next = "]", -- Go to next
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
  efm = {
    config_path = EFM_CONF_PATH,
  },
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
    indent_line = { active = enable_plugins_by_default },
    symbol_outline = { active = enable_plugins_by_default },
    debug = { active = enable_plugins_by_default },
    bqf = { active = enable_plugins_by_default },
    trouble = { active = enable_plugins_by_default },
    floatterm = { active = enable_plugins_by_default },
    spectre = { active = enable_plugins_by_default },
    lsp_rooter = { active = enable_plugins_by_default },
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
    slime = { active = enable_plugins_by_default },
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
  user_autocommands = {
    { "FileType", "qf", "set nobuflisted" },
  },
  lang = {
    python = {
      isort = false,
      diagnostics = diagnostics,
      analysis = {
        type_checking = "basic",
        auto_search_paths = true,
        use_library_code_types = true,
      },
      efm = { active = enable_efm_by_default },
    },
    dart = {
      sdk_path = "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot",
    },
    lua = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    sh = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    tsserver = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    json = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
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
      efm = { active = enable_efm_by_default },
    },
    clang = {
      diagnostics = diagnostics,
      cross_file_rename = true,
      header_insertion = "never",
      efm = { active = enable_efm_by_default },
    },
    ruby = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
      filetypes = { "rb", "erb", "rakefile", "ruby" },
    },
    go = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    elixir = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    vim = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    yaml = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    terraform = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    rust = {
      rust_tools = { active = false },
      linter = "",
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    svelte = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    php = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
      format = { braces = "psr12" },
      environment = { php_version = "7.4" },
      filetypes = { "php", "phtml" },
    },
    latex = {
      vimtex = { active = true },
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
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
      efm = { active = enable_efm_by_default },
    },
    html = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    elm = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    emmet = {
      diagnostics = diagnostics,
      active = false,
    },
    graphql = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    docker = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    cmake = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    java = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    zig = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
    },
    julia = {
      diagnostics = diagnostics,
      efm = { active = enable_efm_by_default },
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
