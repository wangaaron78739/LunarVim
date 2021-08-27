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

  use {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = function(msg, lvl, opts)
        opts.timeout = opts.timemout or O.notify.timeout
        return require "notify"(msg, lvl, opts)
      end
      -- vim.notify = require "notify"
    end,
    disable = not O.plugin.notify,
  }

  -- Lsp Configs
  use { "neovim/nvim-lspconfig" }
  use {
    "kabouzeid/nvim-lspinstall",
    -- https://github.com/williamboman/nvim-lsp-installer
    -- https://github.com/alexaandru/nvim-lspupdate.git
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

  -- -- Coq_nvim based Autocomplete and snippets
  -- use {
  --   "ms-jpq/coq_nvim",
  --   branch = "coq",
  --   config = function()
  --     require("lv-coq").config()
  --   end,
  --   run = ":COQdeps",
  --   disable = not O.plugin.coq,
  -- }
  -- use {
  --   "ms-jpq/coq.artifacts",
  --   branch = "artifacts",
  --   after = "coq_nvim",
  --   disable = not O.plugin.coq,
  -- }

  -- Nvim cmp based completions and snippets
  use {
    "hrsh7th/nvim-cmp",
    config = function()
      require("lv-cmp").setup()
    end,
    -- event = "InsertEnter",
    disable = not O.plugin.cmp,
  }
  use {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init(O.plugin.cmp.lspkind)
    end,
  }
  use { "hrsh7th/cmp-buffer", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  use { "hrsh7th/cmp-path", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  use { "kdheepak/cmp-latex-symbols", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  use { "hrsh7th/cmp-nvim-lsp", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  use { "hrsh7th/cmp-calc", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  -- Tabout
  use {
    "abecodes/tabout.nvim",
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
    disable = not O.plugin.cmp,
  }
  -- VSCode style snippets
  use {
    "L3MON4D3/LuaSnip",
    config = function()
      require("lv-luasnips").setup()
    end,
    disable = not O.plugin.cmp or not O.plugin.luasnip,
  }
  use {
    "saadparwaiz1/cmp_luasnip",
    requires = { "L3MON4D3/LuaSnip", "hrsh7th/nvim-cmp" },
    disable = not O.plugin.cmp or not O.plugin.luasnip,
  }
  -- Common set of snippets
  use { "rafamadriz/friendly-snippets", disable = not O.plugin.luasnip }
  -- Tabnine
  use {
    "tzachar/cmp-tabnine",
    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
    disable = not O.plugin.cmp or not O.plugin.tabnine,
  }

  -- Auto activating snippets -- TODO: port my snippets from vscode
  -- use {
  --   "SirVer/ultisnips",
  --   setup = function()
  --     vim.g.UltiSnipsExpandTrigger = "<f5>"
  --   end,
  -- }
  -- use { "quangnguyen30192/cmp-nvim-ultisnips", disable = not O.plugin.cmp }

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "lv-autopairs"
    end,
    -- after = { "nvim-compe", "telescope.nvim" },
    after = "nvim-cmp",
  }

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

  -- Comments
  use {
    -- "b3nj5m1n/kommentary",
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup {
        hook = function()
          require("ts_context_commentstring.internal").update_commentstring()
        end,
      }
    end,
    event = "BufRead",
    -- event = "BufWinEnter",
    keys = { "gc", "gcc" },
  }

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

  -- Better motions
  use {
    "IndianBoy42/hop.nvim",
    config = function()
      require("lv-hop").config()
    end,
    cmd = { "HopChar2", "HopChar1", "HopWord", "HopLine", "HopPattern" },
    module = "hop",
    disable = not O.plugin.hop,
  }
  -- Enhanced increment/decrement
  use {
    "monaqa/dial.nvim",
    event = "BufRead",
    config = function()
      require("lv-dial").config()
    end,
    disable = not O.plugin.dial,
  }
  -- Dashboard
  use {
    "ChristianChiarulli/dashboard-nvim",
    event = "BufWinEnter",
    cmd = { "Dashboard", "DashboardNewFile", "DashboardJumpMarks" },
    config = function()
      require("lv-dashboard").config()
    end,
    disable = not O.plugin.dashboard,
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
    disable = not O.plugin.zen,
  }

  -- Ranger
  -- use {
  --   "kevinhwang91/rnvimr",
  --   -- cmd = "RnvimrToggle",
  --   config = function()
  --     require("lv-rnvimr").config()
  --   end,
  --   disable = not O.plugin.ranger,
  -- }

  -- matchup
  use {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      require("lv-matchup").config()
    end,
    disable = not O.plugin.matchup,
  }
  use {
    "theHamsta/nvim-treesitter-pairs",
    event = "BufRead",
    disable = not O.plugin.ts_matchup,
  }

  use {
    "norcalli/nvim-colorizer.lua",
    event = "BufWinEnter",
    config = function()
      require "lv-colorizer"
    end,
    disable = not O.plugin.colorizer,
  }

  use {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup(O.plugin.numb)
    end,
    disable = not O.plugin.numb,
  }

  -- Treesitter playground
  use {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    disable = not O.plugin.ts_playground,
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
    disable = not O.plugin.indent_line,
  }

  -- comments in context
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "BufRead",
    disable = not O.plugin.ts_context_commentstring,
  }

  -- Symbol Outline
  use {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    disable = not O.plugin.symbol_outline,
  }
  -- diagnostics
  use {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    disable = not O.plugin.trouble,
    config = function()
      require("lv-trouble").config()
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
    disable = not O.plugin.debug,
  }
  -- Debugger installing
  use {
    "Pocco81/DAPInstall.nvim",
    cmd = { "DIInstall", "DIList", "DIUninstall" },
    module = "dap-install",
    disable = not O.plugin.dap_install,
  }
  -- Better quickfix
  use {
    "kevinhwang91/nvim-bqf",
    event = "BufRead",
    -- cmd = "copen",
    disable = not O.plugin.bqf,
  }
  -- Floating terminal
  use {
    "numToStr/FTerm.nvim",
    event = "BufWinEnter",
    config = function()
      require("fterms").setup()
    end,
    disable = not O.plugin.floatterm,
  }
  -- Search & Replace
  use {
    "windwp/nvim-spectre",
    event = "BufRead", -- TODO: load on command
    config = function()
      require("lv-spectre").setup()
    end,
    disable = not O.plugin.spectre,
  }
  -- lsp root with this nvim-tree will follow you
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup(O.plugin.project_nvim)

      require("telescope").load_extension "projects"
    end,
    disable = not O.plugin.project_nvim,
  }
  -- Markdown preview
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    -- "previm/previm",
    ft = "markdown",
    disable = not O.plugin.markdown_preview,
  }
  -- Interactive scratchpad
  use {
    "metakirby5/codi.vim",
    cmd = "Codi",
    disable = not O.plugin.codi,
  }
  -- Use fzy for telescope
  use {
    "nvim-telescope/telescope-fzy-native.nvim",
    disable = not O.plugin.telescope_fzy,
  }
  -- Use fzf for telescope
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    disable = not O.plugin.telescope_fzf,
  }
  -- Use project for telescope
  use {
    "nvim-telescope/telescope-project.nvim",
    event = "BufRead",
    requires = "telescope.nvim",
    disable = not O.plugin.telescope_project,
  }
  -- Telescope sort by frecency
  use { "tami5/sql.nvim" }
  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      -- require("telescope").load_extension "frecency"
    end,
    disable = not O.plugin.telescope_frecency,
  }
  use { "nvim-telescope/telescope-hop.nvim", requires = "telescope.nvim" }
  -- Sane gx for netrw_gx bug
  use {
    "felipec/vim-sanegx",
    event = "BufRead",
    disable = not O.plugin.sanegx,
  }
  -- Highlight TODO comments
  use {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
    disable = not O.plugin.todo_comments,
  }
  -- LSP Colors
  use {
    "folke/lsp-colors.nvim",
    event = "BufRead",
    disable = not O.plugin.lsp_colors,
  }
  -- Git Blame
  use {
    "f-person/git-blame.nvim",
    setup = function()
      vim.g.gitblame_enabled = 0
    end,
    cmd = "GitBlameToggle",
    disable = not O.plugin.git_blame,
  }
  use {
    "ruifm/gitlinker.nvim",
    event = "BufRead",
    config = function()
      require("gitlinker").setup(O.plugin.gitlinker)
    end,
    disable = not O.plugin.gitlinker,
    requires = "nvim-lua/plenary.nvim",
  }
  -- Octo.nvim
  use {
    "pwntester/octo.nvim",
    cmd = "Octo",
    disable = not O.plugin.octo,
  }
  -- Diffview
  use {
    "sindrets/diffview.nvim",
    event = "BufRead",
    -- ft = 'diff'?
    disable = not O.plugin.diffview,
  }
  -- Easily Create Gists
  use {
    "mattn/vim-gist",
    cmd = "Gist",
    disable = not O.plugin.gist,
    requires = "mattn/webapi-vim",
  }
  -- HTML preview
  use {
    "turbio/bracey.vim",
    -- event = "BufRead",
    ft = "html",
    run = "npm install --prefix server",
    disable = not O.plugin.bracey,
  }

  -- Tmux navigator
  use {
    "christoomey/vim-tmux-navigator",
    disable = not O.plugin.tmux_navigator,
  }

  -- LANGUAGE SPECIFIC GOES HERE

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
    config = function()
      require("lv-rust-tools").setup()
    end,
    -- TODO: use lazy loading maybe?
    -- ft = rust
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
    disable = not O.plugin.flutter_tools,
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

  -- LSP get function signature
  use {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup(O.plugin.lsp_signature)
    end,
  }
  use {
    "kosayoda/nvim-lightbulb",
    config = function()
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end,
    event = "BufRead",
  }

  use { "RishabhRD/popfix" }
  use {
    "RishabhRD/nvim-lsputils",
    config = function()
      vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
      -- vim.lsp.handlers["textDocument/codeLens"] = require("lsp.codeLens").code_lens_handler
      vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
      vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
      vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
      vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
      vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
      -- vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
      -- vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
      vim.cmd [[ au FileType lsputil_codeaction_list nmap <buffer> K <CR> ]]
    end,
  }

  -- See jumpable characters
  use {
    "unblevable/quick-scope",
    event = "BufRead",
    setup = function()
      vim.g.qs_highlight_on_keys = O.plugin.quickscope.on_keys
    end,
    disable = not O.plugin.quickscope,
  }

  -- 2 letter find at lightspeed
  use {
    "ggandor/lightspeed.nvim",
    config = function()
      require("lv-lightspeed").config()
    end,
    disable = not O.plugin.lightspeed,
  }

  -- Multi cursor support
  use {
    "mg979/vim-visual-multi",
    setup = function()
      require("lv-visual-multi").preconf()
    end,
    event = "BufRead",
    disable = not O.plugin.visual_multi,
  }

  -- Surround plugin
  use {
    "machakann/vim-sandwich",
    setup = function()
      require("lv-sandwich").preconf()
    end,
    config = function()
      require("lv-sandwich").config()
    end,
    event = "BufRead",
    disable = not O.plugin.surround,
  }

  -- fzf based search
  use { "junegunn/fzf", disable = not O.plugin.fzf } -- Telescope does most of this?
  use { "junegunn/fzf.vim", disable = not O.plugin.fzf }

  -- Run commands async
  -- use {"skywind3000/asyncrun.vim"}
  -- Build cmake projects from neovim
  -- use {"Shatur95/neovim-cmake"}

  -- Send to terminal
  use {
    "jpalardy/vim-slime",
    setup = function()
      require("lv-slime").preconf()
    end,
    config = function()
      require("lv-slime").config()
    end,
    cmd = {
      "SlimeSend",
      "SlimeSend1",
      "SlimeSendCurrentLine",
      "SlimeConfig",
    },
    disable = not O.plugin.slime,
  }
  -- https://github.com/dccsillag/magma-nvim might be better
  use {
    "dccsillag/magma-nvim",
    config = function()
      require("lv-magma").config()
    end,
    setup = function()
      require("lv-magma").setup()
    end,
    run = ":UpdateRemotePlugins",
    -- python3.9 -m pip install cairosvg pnglatex jupyter_client ipython ueberzug pillow
    ft = { "python", "julia" },
    keys = { "gx", "gxx" },
    cmd = {
      "MagmaEvaluateOperator",
      "MagmaEvaluateVisual",
      "MagmaEvaluateLine",
    },
    disable = not O.plugin.magma,
  }

  -- Better neovim terminal
  use {
    "kassio/neoterm",
    config = function()
      require("lv-neoterm").config()
    end,
    cmd = {
      "T",
      "Tmap",
      "Tnew",
      "Ttoggle",
      "Topen",
      "TREPLSendLine",
      "TREPLSendSelection",
      "TREPLSendFile",
    },
    keys = { "<M-x>", "<M-x><M-x>" },
    disable = not O.plugin.neoterm,
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

  -- mkdir -- FIXME: Goes into a infinite loop and freezes neovim
  use {
    "jghauser/mkdir.nvim",
    config = function()
      require "mkdir"
    end,
  }

  -- Sudo write files
  use { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } }

  -- Vista viewer
  use {
    "liuchengxu/vista.vim",
    disable = not O.plugin.vista,
    cmd = "Vista",
  }

  -- Helper for lists
  -- FIXME: fucks up coq_nvim handling of <CR>
  use {
    "dkarter/bullets.vim",
    ft = { "txt", "markdown" }, -- TODO: what filetypes?
    disable = not O.plugin.bullets,
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
    disable = not O.plugin.ts_textobjects,
  }
  use {
    "RRethy/nvim-treesitter-textsubjects",
    disable = not O.plugin.ts_textsubjects,
    use {
      "David-Kunz/treesitter-unit",
      config = function()
        vim.api.nvim_set_keymap("v", "x", '<cmd>lua require"treesitter-unit".select()<CR>', { noremap = true })
        vim.api.nvim_set_keymap("o", "x", '<cmd><c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
      end,
      disable = not O.plugin.ts_textunits,
    },
  }
  use {
    "mfussenegger/nvim-ts-hint-textobject",
    config = function()
      require("tsht").config.hint_keys = O.treesitter.hint_labels -- Requires https://github.com/mfussenegger/nvim-ts-hint-textobject/pull/2

      mappings.sile("o", "m", [[:<C-U>lua require('tsht').nodes()<CR>]])
      mappings.sile("v", "m", [[:lua require('tsht').nodes()<CR>]])
    end,
    event = "BufRead",
    disable = not O.plugin.ts_hintobjects,
  }
  use {
    "mizlan/iswap.nvim",
    config = function()
      require("iswap").setup(O.plugin.ts_iswap)
    end,
    cmd = { "ISwap", "ISwapWith" },
    disable = not O.plugin.ts_iswap,
  }
  use { "tommcdo/vim-exchange" } -- TODO: may not actually need a whole plugin for this
  use { -- TODO: check if this lazy load is ok
    "windwp/nvim-ts-autotag",
    event = "BufRead",
    disable = not O.plugin.ts_autotag,
  }
  use {
    "romgrk/nvim-treesitter-context",
    event = "CursorMoved",
    disable = not O.plugin.ts_context,
  }
  use { "p00f/nvim-ts-rainbow", disable = not O.plugin.ts_rainbow }
  use { "nvim-treesitter/nvim-treesitter-refactor" }

  -- Startup profiler
  use {
    "tweekmonster/startuptime.vim",
    cmd = "StartupTime",
    disable = not O.plugin.startuptime,
  }

  -- Visual undo tree
  use {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    disable = not O.plugin.undotree,
  }

  -- Vim Doge Documentation Generator
  use {
    "kkoomen/vim-doge",
    run = ":call doge#install()",
    cmd = "DogeGenerate",
    disable = not O.plugin.doge,
  }

  -- Null ls, for hooking local plugins into lsp
  use {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("lv-null-ls").config()
    end,
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  }

  -- 'Smarter' pasting
  use {
    "IndianBoy42/nvim-anywise-reg.lua",
    -- AckslD/nvim-anywise-reg.lua
    event = "BufRead",
    config = function()
      require("anywise_reg").setup(O.plugin.anywise_reg)
    end,
    disable = not O.plugin.anywise_reg,
  }

  -- Editorconfig support
  use {
    "editorconfig/editorconfig-vim",
    event = "BufRead",
    config = function()
      require "lv-editorconfig"
    end,
    disable = not O.plugin.editorconfig,
  }

  -- Doesn't work?
  use {
    "famiu/nvim-reload",
    cmd = { "Reload", "Restart" },
    config = function()
      local reload = require "nvim-reload"
      reload.modules_reload_external = { "packer" }
      reload.vim_reload_dirs = { CONFIG_PATH, PLUGIN_PATH }
      reload.lua_reload_dirs = { CONFIG_PATH, PLUGIN_PATH }
      reload.post_reload_hook = function()
        vim.cmd "noh"
      end
    end,
  }

  use {
    "AndrewRadev/splitjoin.vim",
    setup = function()
      vim.g.splitjoin_split_mapping = "gs"
      vim.g.splitjoin_join_mapping = "gj"
    end,
  }

  use { "Iron-E/nvim-libmodal" }
  -- use { "Iron-E/nvim-tabmode", after = "nvim-libmodal" }

  -- use { "~/code/glow.nvim", run = ":GlowInstall" }

  -- Command line autocomplete
  use {
    "gelguy/wilder.nvim",
    config = function()
      require("lv-wilder").config()
    end,
  }

  -- Primeagens refactoring plugin
  use {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("lv-refactoring").setup()
    end,
    disable = not O.plugin.primeagen_refactoring,
  }

  -- Lua development helper
  use {
    "bfredl/nvim-luadev",
    cmd = "Luadev",
    config = function()
      mappings.sile("n", "<leader>xx", "<Plug>(Luadev-RunLine)")
      mappings.sile("n", "<leader>x", "<Plug>(Luadev-Run)")
      mappings.sile("v", "<leader>x", "<Plug>(Luadev-Run)")
      mappings.sile("n", "<leader>xw", "<Plug>(Luadev-RunWord)")
      mappings.sile("n", "<leader>x<space>", "<Plug>(Luadev-Complete)")
    end,
    ft = "lua",
  }
  use {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
    ft = "lua",
  }

  -- Lowlight code outside the current context
  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {}
    end,
    disable = not O.plugin.twilight,
  }

  -- Colorschemes/Themes
  -- Lush - Create Color Schemes
  use {
    "rktjmp/lush.nvim",
    -- cmd = {"LushRunQuickstart", "LushRunTutorial", "Lushify"},
    disable = not O.plugin.lush,
  }
  -- Colorbuddy colorscheme helper
  use { "tjdevries/colorbuddy.vim", module = "colorbuddy" }
  -- Colorschemes -- https://github.com/folke/lsp-colors.nvim
  use {
    "Yagua/nebulous.nvim",
    config = function()
      vim.g.nb_style = "night"
    end,
  }
  use { "christianchiarulli/nvcode-color-schemes.vim", opt = true }
  use {
    "Pocco81/Catppuccino.nvim",
    config = function()
      require("catppuccino").setup {
        colorscheme = "catppuccino", -- neon_latte
        integrations = setmetatable({}, { -- Return always true
          __index = function(tbl, key)
            return tbl[key] or true
          end,
        }),
      }
    end,
  }
  -- use "RishabhRD/nvim-rdark"
  -- use "marko-cerovac/material.nvim"
  -- use "Shatur/neovim-ayu"
  -- use "folke/tokyonight.nvim"
  -- use "Mofiqul/dracula.nvim"
  -- use "tomasiser/vim-code-dark"
  -- use "glepnir/zephyr-nvim"
  -- use "Th3Whit3Wolf/onebuddy" -- require('colorbuddy').colorscheme('onebuddy')
  -- use "ishan9299/modus-theme-vim"
  -- use "Th3Whit3Wolf/one-nvim"
  -- use "ray-x/aurora"
  -- use "tanvirtin/nvim-monokai"
  -- -- use "nekonako/xresources-nvim"
  -- use "bluz71/vim-moonfly-colors"
  -- use "klooj/noogies"
  -- use { "kuznetsss/meadow-nvim" }
  -- use {
  --   "olimorris/onedark.nvim",
  --   as = "olimorris-onedark-nvim",
  --   requires = "rktjmp/lush.nvim",
  -- }
  -- use { "navarasu/onedark.nvim", as = "navarasu-onedark-nvim" }
  -- use { "ful1e5/onedark.nvim", as = "ful1e5-onedark-nvim" }
  -- use {
  --   "rafamadriz/neon",
  --   config = function()
  --     vim.g.neon_style = "dark"
  --     vim.g.neon_italic_keyword = true
  --     vim.g.neon_italic_function = true
  --     vim.g.neon_transparent = true
  --   end,
  -- }
  -- use { "adisen99/codeschool.nvim", requires = { "rktjmp/lush.nvim" } }

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

  local metatable = {
    __newindex = function(table, repo, options)
      options[1] = table[1] .. "/" .. repo
      use(options)
    end,
  }
  local plugins_table = setmetatable({}, {
    __index = function(table, user)
      return setmetatable({ user }, metatable)
    end,
  })
  -- plugins_table.gelguy["wilder.nvim"] = {
  --   config = function()
  --     require("lv-wilder").config()
  --   end,
  -- }
end)
