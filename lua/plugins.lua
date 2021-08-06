local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

packer.init {
  -- compile_path = vim.fn.stdpath('data')..'/site/pack/loader/start/packer.nvim/plugin/packer_compiled.vim',
  -- compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "plugin", "packer_compiled.vim"),
  compile_path = require("packer.util").join_paths(vim.fn.stdpath "config", "plugin", "packer_compiled.lua"),
  git = { clone_timeout = 300 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
  auto_reload_compiled = true,
}

-- vim.cmd "autocmd BufWritePost plugins.lua luafile %" -- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost lv-config.lua luafile %" -- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost plugins.lua PackerSync" -- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost lv-config.lua PackerSync" -- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua
-- vim.cmd "autocmd BufWritePost lv-config.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
  -- Packer can manage itself as an optional plugin
  use "wbthomason/packer.nvim"

  -- Lsp Configs
  use { "neovim/nvim-lspconfig" }
  use {
    "kabouzeid/nvim-lspinstall",
    config = function()
      require "lv-lspinstall"
    end,
    cmd = "LspInstall",
  }

  -- Utilities
  use { "nvim-lua/popup.nvim" }
  use { "nvim-lua/plenary.nvim" }
  use { "tjdevries/astronauta.nvim" }

  -- Telescope - search through things
  use {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "lv-telescope"
    end,
    -- cmd = "Telescope"
  }
  -- Snap
  use {
    "camspiers/snap",
    rocks = "fzy",
    config = function()
      require("lv-snap").config()
    end,
    disable = not O.plugin.snap.active,
  }

  -- Autocomplete
  use {
    "hrsh7th/nvim-compe",
    config = function()
      require("lv-compe").config()
    end,
    -- event = "InsertEnter",
  }

  -- VSCode style snippets
  use { "hrsh7th/vim-vsnip", event = "InsertEnter" }
  -- use {"hrsh7th/vim-vsnip-integ", event = "InsertEnter", after = "vim-vsnip"}
  use { "rafamadriz/friendly-snippets", event = "InsertEnter" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  use {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    config = function()
      require("lv-nvimtree").config()
    end,
  }

  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("lv-gitsigns").config()
    end,
    event = "BufRead",
  }

  -- whichkey
  use { "folke/which-key.nvim" }

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "lv-autopairs"
    end,
    -- after = { "nvim-compe", "telescope.nvim" },
    after = "telescope.nvim",
  }

  -- Comments
  use {
    -- "b3nj5m1n/kommentary",
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
      --  -- Fix gcc keymapping -- Doesn't work with lazy load?
      -- FIXME: why doesn't this work, which-key is so weird
      --vim.api.nvim_set_keymap("n", "gc", "<cmd>kommentary_motion_default<cr>", { noremap = true, silent = true })
      --vim.api.nvim_set_keymap("n", "gcc", "<cmd>kommentary_line_default<cr>", { noremap = true, silent = true })
    end,
    event = "BufRead",
    -- event = "BufWinEnter",
    keys = { "gc", "gcc" },
  }

  -- Color
  use { "christianchiarulli/nvcode-color-schemes.vim", opt = true }

  -- Icons
  use { "kyazdani42/nvim-web-devicons" }

  -- Status Line and Bufferline
  use {
    "glepnir/galaxyline.nvim",
    config = function()
      require "lv-galaxyline"
    end,
  }

  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("lv-bufferline").config()
    end,
    --         "romgrk/barbar.nvim",
    --         config = function()
    --             require 'lv-barbar'.config()
    --         end,
    -- event = "BufRead",
  }

  -- Extras, these do not load by default

  -- Better motions
  use {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("lv-hop").config()
    end,
    disable = not O.plugin.hop.active,
  }
  -- Enhanced increment/decrement
  use {
    "monaqa/dial.nvim",
    cmd = { "DialIncrement", "DialDecrement" },
    config = function()
      require("lv-dial").config()
    end,
    disable = not O.plugin.dial.active,
  }
  -- Dashboard
  use {
    "ChristianChiarulli/dashboard-nvim",
    event = "BufWinEnter",
    cmd = { "Dashboard", "DashboardNewFile", "DashboardJumpMarks" },
    config = function()
      require("lv-dashboard").config()
    end,
    disable = not O.plugin.dashboard.active,
  }
  -- Zen Mode
  use {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
    -- "folke/zen-mode.nvim",
    -- cmd = "ZenMode",
    config = function()
      require("lv-zen").config()
    end,
    disable = not O.plugin.zen.active,
  }

  -- Ranger
  -- use {
  --   "kevinhwang91/rnvimr",
  --   -- cmd = "RnvimrToggle",
  --   config = function()
  --     require("lv-rnvimr").config()
  --   end,
  --   disable = not O.plugin.ranger.active,
  -- }

  -- matchup
  use {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      require("lv-matchup").config()
    end,
    disable = not O.plugin.matchup.active,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufWinEnter",
    config = function()
      require "lv-colorizer"
    end,
    disable = not O.plugin.colorizer.active,
  }

  use {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
    disable = not O.plugin.numb.active,
  }

  -- Treesitter playground
  use {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    disable = not O.plugin.ts_playground.active,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "InsertEnter",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"

      vim.g.indent_blankline_filetype_exclude = {
        "help",
        "terminal",
        "dashboard",
      }
      vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }

      vim.g.indent_blankline_char_highlight = "LineNr"
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
    end,
    disable = not O.plugin.indent_line.active,
  }

  -- comments in context
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
    disable = not O.plugin.ts_context_commentstring.active,
  }

  -- Symbol Outline
  use {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    disable = not O.plugin.symbol_outline.active,
  }
  -- diagnostics
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    disable = not O.plugin.trouble.active,
    config = function()
      -- TODO: move this to a separate file
      vim.cmd [[
            autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * TroubleRefresh
            ]]

      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        position = "right",
        auto_preview = false,
        hover = "h",
      }
    end,
  }
  -- Debugging
  use {
    "mfussenegger/nvim-dap",
    -- TODO: load on command
    config = function()
      require "lv-dap"
    end,
    module = "dap",
    disable = not O.plugin.debug.active,
  }
  -- Debugger installing
  use {
    "Pocco81/DAPInstall.nvim",
    cmd = { "DIInstall", "DIList", "DIUninstall" },
    module = "dap-install",
    disable = not O.plugin.dap_install.active,
  }
  -- Better quickfix
  use {
    "kevinhwang91/nvim-bqf",
    event = "BufRead",
    -- cmd = "copen",
    disable = not O.plugin.bqf.active,
  }
  -- Floating terminal
  use {
    "numToStr/FTerm.nvim",
    event = "BufWinEnter",
    config = function()
      require "fterms"
    end,
    disable = not O.plugin.floatterm.active,
  }
  -- Search & Replace
  use {
    "windwp/nvim-spectre",
    event = "BufRead", -- TODO: load on command
    config = function()
      require("lv-spectre").setup()
    end,
    disable = not O.plugin.spectre.active,
  }
  -- lsp root with this nvim-tree will follow you
  use {
    "ahmedkhalf/lsp-rooter.nvim",
    event = "BufRead",
    config = function()
      require("lsp-rooter").setup()
    end,
    disable = not O.plugin.lsp_rooter.active,
  }
  -- Markdown preview
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    -- "previm/previm",
    ft = "markdown",
    disable = not O.plugin.markdown_preview.active,
  }
  -- Interactive scratchpad
  use {
    "metakirby5/codi.vim",
    cmd = "Codi",
    disable = not O.plugin.codi.active,
  }
  -- Use fzy for telescope
  use {
    "nvim-telescope/telescope-fzy-native.nvim",
    event = "BufRead",
    after = "telescope.nvim",
    disable = not O.plugin.telescope_fzy.active,
  }
  -- Use project for telescope
  use {
    "nvim-telescope/telescope-project.nvim",
    event = "BufRead",
    requires = "telescope.nvim",
    -- setup = function () vim.cmd[[packadd telescope.nvim]] end,
    disable = not O.plugin.telescope_project.active,
  }
  -- Sane gx for netrw_gx bug
  use {
    "felipec/vim-sanegx",
    event = "BufRead",
    disable = not O.plugin.sanegx.active,
  }
  -- Highlight TODO comments
  use {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
    disable = not O.plugin.todo_comments.active,
  }
  -- LSP Colors
  use {
    "folke/lsp-colors.nvim",
    event = "BufRead",
    disable = not O.plugin.lsp_colors.active,
  }
  -- Git Blame
  use {
    "f-person/git-blame.nvim",
    cmd = "GitBlameToggle",
    disable = not O.plugin.git_blame.active,
  }
  use {
    "ruifm/gitlinker.nvim",
    event = "BufRead",
    config = function()
      require("gitlinker").setup {
        opts = {
          -- remote = 'github', -- force the use of a specific remote
          -- adds current line nr in the url for normal mode
          add_current_line_on_normal_mode = true,
          -- callback for what to do with the url
          action_callback = require("gitlinker.actions").open_in_browser,
          -- print the url after performing the action
          print_url = false,
          -- mapping to call url generation
          mappings = "<leader>gy",
        },
      }
    end,
    disable = not O.plugin.gitlinker.active,
    requires = "nvim-lua/plenary.nvim",
  }
  -- Octo.nvim
  use {
    "pwntester/octo.nvim",
    cmd = "Octo",
    disable = not O.plugin.octo.active,
  }
  -- Diffview
  use {
    "sindrets/diffview.nvim",
    event = "BufRead",
    -- ft = 'diff'?
    disable = not O.plugin.diffview.active,
  }
  -- Easily Create Gists
  use {
    "mattn/vim-gist",
    cmd = "Gist",
    disable = not O.plugin.gist.active,
    requires = "mattn/webapi-vim",
  }
  -- Lush Create Color Schemes
  use {
    "rktjmp/lush.nvim",
    -- cmd = {"LushRunQuickstart", "LushRunTutorial", "Lushify"},
    disable = not O.plugin.lush.active,
  }
  -- HTML preview
  use {
    "turbio/bracey.vim",
    -- event = "BufRead",
    ft = "html",
    run = "npm install --prefix server",
    disable = not O.plugin.bracey.active,
  }

  -- Tmux navigator
  use {
    "christoomey/vim-tmux-navigator",
    disable = not O.plugin.tmux_navigator.active,
  }

  -- Tabnine
  use {
    "tzachar/compe-tabnine",
    run = "./install.sh",
    after = "nvim-compe",
    -- event = "InsertEnter",
    disable = not O.plugin.tabnine.active,
  }

  -- LANGUAGE SPECIFIC GOES HERE

  -- Null ls, for hooking local plugins into lsp
  -- use {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   ft = {
  --     "javascript",
  --     "javascriptreact",
  --     "javascript.jsx",
  --     "typescript",
  --     "typescriptreact",
  --     "typescript.tsx",
  --   },
  --   config = function()
  --     require("null-ls").setup()
  --   end,
  -- }

  -- Latex
  -- TODO what filetypes should this be active for?
  use {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("lv-vimtex").config()
    end,
    disable = not O.lang.latex.vimtex.active,
  }

  -- Rust tools
  use {
    "simrat39/rust-tools.nvim",
    -- TODO: use lazy loading maybe?
    disable = not O.lang.rust.rust_tools.active,
  }

  -- Elixir
  use { "elixir-editors/vim-elixir", ft = { "elixir", "eelixir", "euphoria3" } }

  -- Javascript / Typescript
  use {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
  }

  -- Flutter
  use {
    "akinsho/flutter-tools.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require "lv-flutter-tools"
    end,
    disable = not O.plugin.flutter_tools.active,
    ft = "dart",
  }

  -- Justfile
  use { "NoahTheDuke/vim-just", ft = "just" }

  -- Fish shell
  -- use {"dag/vim-fish", ft = 'fish'} -- Treesitter highlighting is fine

  -- KMonad
  use { "kmonad/kmonad-vim", ft = "kmonad" }

  -- Json querying
  use { "gennaro-tedesco/nvim-jqx", ft = "json" }

  -------------------------------------------------------------------
  -------------------------------------------------------------------
  -- amedhi plugins

  -- LSP get function signature
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      local lsp_sign_opt = O.plugin.lsp_signature
      lsp_sign_opt.bind = true
      lsp_sign_opt.handler_opts = {
        border = O.lsp.border, -- double, single, shadow, none
      }
      lsp_sign_opt.hint_scheme = "String"
      lsp_sign_opt.hi_parameter = "Search"
      require("lsp_signature").setup(lsp_sign_opt)
    end,
  }

  use { "RishabhRD/popfix" }
  use {
    "RishabhRD/nvim-lsputils",
    config = function()
      vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
      vim.cmd [[
        au FileType lsputil_codeaction_list nmap <buffer> K <CR>
      ]]
      -- vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
      -- vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
      -- vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
      -- vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
      -- vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
      -- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
      -- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
    end,
  }

  -- See jumpable characters
  use {
    "unblevable/quick-scope",
    keys = O.plugin.quickscope.on_keys,
    event = (O.plugin.quickscope.on_keys == nil) and "BufRead" or nil,
    config = function()
      vim.g.qs_highlight_on_keys = O.plugin.quickscope.on_keys
    end,
    disable = not O.plugin.quickscope.active,
  }

  -- 2 letter find at lightspeed
  use {
    "ggandor/lightspeed.nvim",
    config = function()
      require("lv-lightspeed").config()
    end,
    disable = not O.plugin.lightspeed.active,
  }

  -- Multi cursor support
  use { "mg979/vim-visual-multi", disable = not O.plugin.visual_multi.active, event = "BufRead" }

  -- Surround plugin
  use {
    "machakann/vim-sandwich",
    config = function()
      vim.api.nvim_command "runtime macros/sandwich/keymap/surround.vim"
      vim.api.nvim_command [[
        xmap is <Plug>(textobj-sandwich-query-i)
        xmap as <Plug>(textobj-sandwich-query-a)
        omap is <Plug>(textobj-sandwich-query-i)
        omap as <Plug>(textobj-sandwich-query-a)
    ]]
    end,
    event = "BufRead",
    disable = not O.plugin.surround.active,
  }

  -- fzf based search
  use { "junegunn/fzf", disable = not O.plugin.fzf.active } -- Telescope does most of this?
  use { "junegunn/fzf.vim", disable = not O.plugin.fzf.active }

  -- Run commands async
  -- use {"skywind3000/asyncrun.vim"}
  -- Build cmake projects from neovim
  -- use {"Shatur95/neovim-cmake"}

  -- Auto activating snippets
  -- use {"SirVer/ultisnips"} -- TODO: port my snippets from vscode

  -- Send to terminal
  use {
    "jpalardy/vim-slime",
    disable = not O.plugin.slime.active,
    cmd = {
      "SlimeSend",
      "SlimeSend0",
      "SlimeSendCurrentLine",
      "SlimeConfig",
    },
  }

  -- Better neovim terminal
  use {
    "kassio/neoterm",
    config = "require('lv-neoterm')",
    cmd = { "T", "Tmap", "Tnew", "Ttoggle", "Topen" },
    keys = { "gx", "gxx" },
  }

  -- Repeat plugin commands
  use { "tpope/vim-repeat", event = "BufRead" }

  -- Smart abbreviations, substitutions and case renaming
  use {
    "tpope/vim-abolish",
    event = "InsertEnter",
    config = function()
      require "lv-abolish"
    end,
  }

  -- See more character information in ga
  use { "tpope/vim-characterize", keys = { "ga" } }

  -- Readline bindings
  -- https://github.com/tpope/vim-rsi

  -- Detect indentation from file
  -- use { "zsugabubus/crazy8.nvim", event = "BufRead" }

  -- mkdir -- Goes into a infinite loop and freezes neovim
  -- use {
  --   "jghauser/mkdir.nvim",
  --   config = function()
  --     require "mkdir"
  --   end,
  --   event = "BufWritePre",
  -- }

  -- Sudo write files
  use { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } }

  -- Vista viewer
  use {
    "liuchengxu/vista.vim",
    disable = not O.plugin.vista.active,
    cmd = "Vista",
  }

  -- Helper for lists
  use {
    "dkarter/bullets.vim",
    ft = { "txt", "markdown" }, -- TODO: what filetypes?
    disable = not O.plugin.bullets.active,
  }

  -- 'smooth' scrolling
  --[[ use {
    "karb94/neoscroll.nvim",
    require("neoscroll").setup {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
      hide_cursor = false, -- Hide cursor while scrolling
      stop_eof = false, -- Stop at <EOF> when scrolling downwards
      respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
      cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
      easing_function = "sine",        -- Default easing function
    },
  } ]]

  -- Code Minimap
  use {
    "wfxr/minimap.vim",
    event = "BufWinEnter",
    run = "cargo install --locked code-minimap",
    config = function()
      table.insert(vim.g.minimap_block_filetypes, "dashboard")
      vim.g.minimap_width = 2 -- Like a scrollbar
      -- vim.g.minimap_highlight_search = true
      -- vim.g.minimap_highlight_range = true
    end,
  }

  -- Session Management
  use { "rmagatti/auto-session" }
  use { "rmagatti/session-lens" }
  -- https://github.com/tpope/vim-obsession

  -- treesitter extensions
  use {
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    "jacfger/nvim-treesitter-textobjects",
    disable = not O.plugin.ts_textobjects.active,
  }
  use {
    "RRethy/nvim-treesitter-textsubjects",
    disable = not O.plugin.ts_textsubjects.active,
  }
  use {
    "mfussenegger/nvim-ts-hint-textobject",
    config = function()
      -- vim.g.ts_hint_textobject_keys = O.treesitter.hint_labels -- Requires https://github.com/mfussenegger/nvim-ts-hint-textobject/pull/2
      require("tsht").config.hint_keys = O.treesitter.hint_labels -- Requires https://github.com/mfussenegger/nvim-ts-hint-textobject/pull/2
    end,
    event = "BufRead",
    disable = not O.plugin.ts_hintobjects.active,
  }
  use { "mizlan/iswap.nvim", cmd = { "ISwap", "ISwapWith" }, disable = not O.plugin.ts_iswap.active }
  use { -- TODO: check if this lazy load is ok
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    disable = not O.plugin.ts_autotag.active,
  }
  use {
    "romgrk/nvim-treesitter-context",
    event = "CursorMoved",
    disable = not O.plugin.ts_context.active,
  }
  use { "p00f/nvim-ts-rainbow", disable = not O.plugin.ts_rainbow.active }

  -- Startup profiler
  use {
    "tweekmonster/startuptime.vim",
    cmd = "StartupTime",
    disable = not O.plugin.startuptime.active,
  }

  -- Visual undo tree
  use { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeShow" }, disable = not O.plugin.undotree.active }

  -- Vim Doge Documentation Generator
  use {
    "kkoomen/vim-doge",
    run = ":call doge#install()",
    cmd = "DogeGenerate",
    disable = not O.plugin.doge.active,
  }

  -- Autoformat everything
  use {
    "sbdchd/neoformat",
    config = function()
      require("lv-neoformat").config()
    end,
    -- event = "BufRead",
    event = "BufWritePre",
    cmd = "Neoformat",
  }

  -- 'Smarter' pasting
  use {
    "IndianBoy42/nvim-anywise-reg.lua",
    -- AckslD/nvim-anywise-reg.lua
    event = "BufRead",
    config = function()
      require("anywise_reg").setup {
        operators = { "y", "d" }, -- putting 'c' breaks it (wrong insert mode cursor)
        registers = { "+", "a" },
        textobjects = {
          { "a", "i" }, -- Add 'i' if you want to track inner selections as well
          -- TODO: how to auto get all the textobjects in the world
          { "w", "W", "b", "B", "(", "a", "f", "m", "s", "/", "c" },
        },
        paste_keys = { ["p"] = "p", ["P"] = "P" },
        register_print_cmd = false,
      }
    end,
    disable = not O.plugin.anywise_reg.active,
  }

  -- Editorconfig support
  use {
    "editorconfig/editorconfig-vim",
    event = "BufRead",
    config = function()
      require "lv-editorconfig"
    end,
    disable = not O.plugin.editorconfig.active,
  }

  -- Doesn't work?
  use {
    "famiu/nvim-reload",
    cmd = { "Reload", "Restart" },
    config = function()
      local reload = require "nvim-reload"
      reload.modules_reload_external = { "packer" }
      reload.vim_reload_dirs = {
        CONFIG_PATH,
        PLUGIN_PATH,
      }
      reload.lua_reload_dirs = {
        CONFIG_PATH,
        PLUGIN_PATH,
      }
      reload.post_reload_hook = function()
        vim.cmd "noh"
      end
    end,
  }

  use {
    "AndrewRadev/splitjoin.vim",
    config = function()
      vim.api.nvim_set_keymap("n", "gj", "gJ", {})
      vim.api.nvim_set_keymap("n", "gk", "gS", {})
    end,
  }

  use { "Iron-E/nvim-libmodal" }
  -- use { "Iron-E/nvim-tabmode", after = "nvim-libmodal" }

  -- use { "~/code/glow.nvim", run = ":GlowInstall" }

  use {
    "abecodes/tabout.nvim",
    config = function()
      local pairs = {
        "''",
        '""',
        "``",
        "()",
        "{}",
        "[]",
      }
      require("tabout").setup {
        tabkey = "", -- key to trigger tabout
        backwards_tabkey = "", -- key to trigger tabout
        act_as_tab = true, -- shift content if tab out is not possible
        completion = true, -- if the tabkey is used in a completion pum
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
          { open = "(", close = ")" },
          { open = "[", close = "]" },
          { open = "{", close = "}" },
        },
        ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
        exclude = {}, -- tabout will ignore these filetypes
      }
    end,
    after = { "nvim-compe" }, -- if a completion plugin is using tabs load it before
  }

  use {
    "gelguy/wilder.nvim",
    config = function()
      require("lv-wilder").config()
    end,
  }

  if #O.custom_plugins > 0 then
    use(O.custom_plugins)
  end

  -- Colorschemes
  -- use {'marko-cerovac/material.nvim'}
  -- use {'folke/tokyonight.nvim'}
  -- use {'Mofiqul/dracula.nvim'}
  -- use {'tomasiser/vim-code-dark'}

  -- -- Explore tar archives
  -- use { "vim-scripts/tar.vim" }

  -- TODO: add and configure these packages
  -- Git
  -- use {'tpope/vim-fugitive', opt = true}
  -- use {'tpope/vim-rhubarb'}

  -- https://github.com/rockerBOO/awesome-neovim -- collection

  -- alt nvim ide
  -- https://github.com/ibhagwan/nvim-lua
  -- https://github.com/lvim-tech/lvim
  -- https://github.com/NTBBloodbath/doom-nvim
  -- https://github.com/MenkeTechnologies/zpwr#zpwr-features

  -- https://github.com/kevinhwang91/nvim-hlslens
  -- https://github.com/gcmt/wildfire.vim -- ts hint textobjects seems okay for this
  -- https://github.com/neomake/neomake
  -- https://github.com/tversteeg/registers.nvim -- which-key provides this
  -- https://github.com/jbyuki/nabla.nvim
  -- https://github.com/justinmk/vim-dirvish -- netrw/nvim-tree alternative
end)
