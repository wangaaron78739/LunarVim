_G.CONFIG_PATH = vim.fn.stdpath "config"
_G.DATA_PATH = vim.fn.stdpath "data"
_G.CACHE_PATH = vim.fn.stdpath "cache"
_G.PLUGIN_PATH = _G.DATA_PATH .. "site/pack/*/start/*"
_G.TERMINAL = vim.fn.expand "$TERMINAL"
_G.LSP_INSTALL_PATH = DATA_PATH .. "/lspinstall"

-- TODO: Cleanup this config struct
O = {
  format_on_save = true,
  format_on_save_timeout = 1000,
  auto_close_tree = false,
  fold_columns = "0",
  theme = "Catppuccin",
  lighttheme = "ModusOperandi", -- Paper is good but incompatible with notify.nvim
  fontsize = 10,
  bigfontsize = 14,
  auto_complete = true,
  colorcolumn = "99999",
  clipboard = "unnamedplus",
  hidden_files = true,
  wrap_lines = false,
  spell = false,
  spelllang = "en",
  number = false,
  relative_number = true,
  number_width = 2,
  shift_width = 4,
  tab_stop = 4,
  cmdheight = 2,
  cursorline = true,
  shell = "bash", -- shell is used for running scripts
  termshell = "fish", -- termshell is used for interactive terminals
  timeoutlen = 300,
  disable_netrw = 0,
  ignore_case = true,
  smart_case = true,
  scrolloff = 10,
  lushmode = false,
  hl_search = true,
  inc_subs = "split",
  transparent_window = false,
  leader_key = "space",
  local_leader_key = ",",
  signcolumn = "number", -- "yes" for always
  notify = {
    timeout = 2000, -- 5000 default
    stages = "fade_in_slide_out",
    background_colour = "Normal",
  },
  breakpoint_sign = { text = "🛑", texthl = "LspDiagnosticsSignError", linehl = "", numhl = "" },
  input_border = "rounded",
  lsp = {
    document_highlight = true,
    autoecho_line_diagnostics = false,
    live_codelens = true,
    -- none, single, double, rounded, solid, shadow, array(fullcustom)
    border = "rounded",
    rename_border = "none",
    diagnostics = {
      virtual_text = { spacing = 4, prefix = "", severity_limit = "Warning" },
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false, -- FIXME: fucks around with the rendering
    },
    codeLens = {
      virtual_text = { spacing = 0, prefix = "" },
      signs = true,
      underline = true,
      severity_sort = true,
    },
    flags = {
      debounce_text_changes = 150,
    },
  },
  filetypes = {
    extension = {
      kbd = "kmonad",
      fish = "fish",
      just = "just",
    },
    literal = {
      Justfile = "just",
      justfile = "just",
    },
  },
  python_interp = CONFIG_PATH .. "/.venv/bin/python3.9", -- TODO: make a venv for this
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
      inner = "i", -- Select inside
      outer = "a", -- Selct around
      -- swap = '<leader>a'
      swap_next = ")", -- Swap with next
      swap_prev = "(", -- Swap with previous
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
      ["loop"] = { "r", "R" },
      ["statement"] = { "l", "L" },
      ["comment"] = { "/", "?" },
    },
    other_suffixes = {
      ["scope"] = { "S", "s" },
      ["element"] = { "e", "E" },
      ["subject"] = { "z", "Z" },
    },
  },
  -- The below is used for most hint based navigation/selection (hop, hint_textobjects)
  -- hint_labels = "fdsahjklgvcxznmbyuiorewqtp",
  hint_labels = "fdsahjklvcxznmewuio",
  database = { save_location = "~/.config/nvim/.db", auto_execute = 1 },
  plugin = {
    copilot = {
      key = "<M-n>",
    },
    yabs = true,
    fugitive = true,
    better_escape = {
      mapping = { "jk", "kj" },
      keys = "<Esc>",
    },
    hop = { teasing = true },
    twilight = true,
    notify = true,
    dial = true,
    dashboard = true,
    -- matchup = true,
    colorizer = true,
    numb = {
      show_numbers = true, -- Enable 'number' for the window while peeking
      show_cursorline = true, -- Enable 'cursorline' for the window while peeking
    },
    zen = true,
    ts_playground = true,
    ts_context_commentstring = true,
    ts_textobjects = true,
    ts_autotag = true,
    ts_textsubjects = true,
    ts_textunits = true,
    ts_rainbow = true,
    ts_context = true,
    ts_hintobjects = { key = "m" },
    ts_matchup = true,
    indent_line = true,
    symbol_outline = true,
    debug = true,
    bqf = true,
    sidebarnvim = true,
    trouble = true,
    floatterm = true,
    spectre = true,
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
      -- ignore_lsp = true,
    },
    markdown_preview = true,
    codi = true,
    telescope_fzy = true,
    telescope_frecency = true,
    telescope_fzf = true,
    ranger = true,
    todo_comments = true,
    lsp_colors = true,
    lsp_signature = {
      doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
      -- Apply indentation for wrapped lines
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
      check_client_handlers = false,
    },
    git_blame = true,
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
        -- ignore_lsp = true,
      },
    },
    lazygit = true,
    octo = true,
    lush = true,
    diffview = true,
    bracey = true,
    telescope_project = true,
    gist = true,
    dap_install = true,
    visual_multi = true,
    lightspeed = true, -- Uses lightspeed.nvim
    quickscope = {
      -- event = "BufRead"
      -- on_keys = { "f", "F", "t", "T" }, -- Comment this line to have it always visible
    },
    surround = true, -- Uses vim-sandwhich
    fzf = true,
    magma = true,
    neoterm = true,
    bullets = true,
    vista = true,
    startuptime = true,
    tabnine = true,
    tmux_navigator = true,
    flutter_tools = true,
    editorconfig = true,
    anywise_reg = {
      operators = { "y", "d" }, -- putting 'c' breaks it (wrong insert mode cursor)
      registers = { "+", "a" },
      textobjects = {
        { "a", "i" }, -- Add 'i' if you want to track inner selections as well
        -- TODO: how to auto get all the textobjects in the world
        { "w", "W", "b", "B", "(", "a", "f", "m", "s", "/", "c" },
      },
      paste_keys = { p = "p", P = "P" },
      register_print_cmd = false,
    },
    doge = true,
    undotree = true,
    ts_iswap = { autoswap = true },
    coq = true,
    cmp = {
      lspkind = {
        with_text = false,
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
    luasnip = true,
    luadev = true,
    luapad = true,
    primeagen_refactoring = true,
    splitfocus = {
      -- width =
      -- treewidth =
      -- height =
      winhighlight = false,
      hybridnumber = false,
      -- signcolumn = "number",
      signcolumn = false,
      relative_number = false,
      number = false,
      -- cursorline = O.cursorline,
    },
    rust_tools = true,
    vimtex = true,
    -- neoscroll = {
    --   -- All these keys will be mapped to their corresponding default scrolling animation
    --   mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    --   hide_cursor = false, -- Hide cursor while scrolling
    --   stop_eof = false, -- Stop at <EOF> when scrolling downwards
    --   respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    --   cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    --   easing_function = "sine", -- Default easing function
    -- },
    gesture = true,
    coderunner = true,
    sniprun = true,
    kittyrunner = true,
    lsputils = {
      handlers = {
        ["textDocument/codeAction"] = { "codeAction", "code_action_handler" },
        -- ["textDocument/codeLens"] = { "codeLens", "code_lens_handler" },
        ["textDocument/references"] = { "locations", "references_handler" },
        ["textDocument/definition"] = { "locations", "definition_handler" },
        ["textDocument/declaration"] = { "locations", "declaration_handler" },
        ["textDocument/typeDefinition"] = { "locations", "typeDefinition_handler" },
        ["textDocument/implementation"] = { "locations", "implementation_handler" },
        -- ["textDocument/documentSymbol"] = { "symbols", "document_handler" },
        -- ["workspace/symbol"] = { "symbols", "workspace_handler" },
      },
      aus = {
        _lsputil_codeaction_list = {
          { "FileType", "lsputil_codeaction_list", "nmap <buffer> K <CR>" },
        },
      },
    },
  },
}
vim.cmd('let &titleold="' .. _G.TERMINAL .. '"')
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
  "ts_textunits",
  "ranger",
}
for _, v in ipairs(disable_plugins) do
  O.plugin[v] = false
end
