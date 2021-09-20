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

return packer.startup(function(use)
  local use_rock = packer.use_rocks
  -- local BufRead
  local BufRead = "BufRead"
  -- Packer can manage itself as an optional plugin
  use "wbthomason/packer.nvim"
  use "lewis6991/impatient.nvim" -- Will be merged in https://github.com/neovim/neovim/pull/15436

  use_rock { "f-strings", "penlight" }

  use {
    "rcarriga/nvim-notify",
    config = function()
      require("lv-notify").config()
    end,
    disable = not O.plugin.notify,
  }

  -- Lsp Configs
  use { "neovim/nvim-lspconfig" }
  -- use "williamboman/nvim-lsp-installer"
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
  }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- whichkey
  use { "folke/which-key.nvim" }

  -- Coq_nvim based Autocomplete and snippets
  use {
    "ms-jpq/coq_nvim",
    branch = "coq",
    config = function()
      require("lv-coq").config()
    end,
    run = ":COQdeps",
    disable = not O.plugin.coq,
  }
  use {
    "ms-jpq/coq.artifacts",
    branch = "artifacts",
    after = "coq_nvim",
    disable = not O.plugin.coq,
  }

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
  use { "hrsh7th/cmp-nvim-lua", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  use { "f3fora/cmp-spell", requires = "hrsh7th/nvim-cmp", disable = not O.plugin.cmp }
  -- Tabout
  use {
    "abecodes/tabout.nvim",
    config = function()
      require("lv-tabout").config()
    end,
    after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
    event = "InsertEnter",
    disable = not O.plugin.cmp,
  }
  -- Snippets plugin
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

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require "lv-autopairs"
    end,
    -- after = { "nvim-compe", "telescope.nvim" },
    after = "nvim-cmp",
    event = "InsertEnter",
  }

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
    event = BufRead,
  }

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
    event = BufRead,
  }

  -- Create pretty comment frames
  use {
    "s1n7ax/nvim-comment-frame",
    config = function()
      require("nvim-comment-frame").setup {
        keymap = "gcf",
        multiline_keymap = "gC",
      }
    end,
  }

  -- Icons
  use { "kyazdani42/nvim-web-devicons" }

  -- Status Line and Bufferline
  use {
    "shadmansaleh/lualine.nvim",
    config = function()
      require "lv-lualine"
    end,
  }
  use "nvim-lua/lsp-status.nvim"
  use "SmiteshP/nvim-gps"

  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("lv-bufferline").config()
    end,
    --         "romgrk/barbar.nvim",
    --         config = function()
    --             require 'lv-barbar'.config()
    --         end,
    -- event = BufRead,
  }
  use { "famiu/bufdelete.nvim", cmd = { "Bdelete", "Bwipeout" } }

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
    config = function()
      require("lv-dial").config()
    end,
    module = "dial",
    disable = not O.plugin.dial,
  }
  -- Dashboard
  use {
    "glepnir/dashboard-nvim",
    event = "BufWinEnter",
    cmd = { "Dashboard", "DashboardNewFile", "DashboardJumpMarks" },
    setup = function()
      require("lv-dashboard").preconf()
    end,
    config = function()
      require("lv-dashboard").config()
    end,
    disable = not O.plugin.dashboard,
  }
  -- TODO: try https://github.com/goolord/alpha-nvim (new dashboard plugin)

  -- Ranger
  use {
    "kevinhwang91/rnvimr",
    -- cmd = "RnvimrToggle",
    config = function()
      require("lv-rnvimr").config()
    end,
    disable = not O.plugin.ranger,
  }

  -- matchup
  use {
    "andymass/vim-matchup",
    event = "CursorMoved",
    setup = function()
      require("lv-matchup").config()
    end,
    disable = not O.plugin.matchup,
  }
  use {
    "theHamsta/nvim-treesitter-pairs",
    event = BufRead,
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
    event = BufRead,
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
    event = BufRead,
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
    event = BufRead,
    disable = not O.plugin.ts_context_commentstring,
  }

  -- Symbol Outline
  use {
    "simrat39/symbols-outline.nvim",
    setup = function()
      require("lv-symbols-outline").preconf()
    end,
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
  -- Vista viewer (symbols)
  use {
    "liuchengxu/vista.vim",
    disable = not O.plugin.vista,
    cmd = "Vista",
  }
  -- Generic sidebar plugin
  use {
    "GustavoKatel/sidebar.nvim",
    config = function()
      require("lv-sidebar").config()
    end,
    cmd = "SidebarNvimToggle",
    disable = not O.plugin.sidebarnvim,
  }
  -- Debugging
  use {
    "mfussenegger/nvim-dap",
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
    event = "QuickFixCmdPre",
    -- cmd = "copen",
    disable = not O.plugin.bqf,
  }
  -- Floating terminal
  use {
    "numToStr/FTerm.nvim",
    event = "BufWinEnter",
    config = function()
      require("lv-terms").fterm()
    end,
    disable = not O.plugin.floatterm,
  }
  -- Search & Replace
  use {
    "windwp/nvim-spectre",
    module = "spectre",
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
    cmd = "ProjectRoot",
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
    event = BufRead,
    requires = "telescope.nvim",
    disable = not O.plugin.telescope_project,
  }
  -- Telescope sort by frecency
  use { "tami5/sqlite.lua" }
  use { -- FIXME: load_extension doesn't work
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      -- require("telescope").load_extension "frecency"
    end,
    requires = { "tami5/sqlite.lua" },
    disable = not O.plugin.telescope_frecency,
  }
  use { "nvim-telescope/telescope-hop.nvim", requires = "telescope.nvim" }
  -- Sane gx for netrw_gx bug
  use {
    "felipec/vim-sanegx",
    event = BufRead,
    disable = not O.plugin.sanegx,
  }
  -- Highlight TODO comments
  use {
    "folke/todo-comments.nvim",
    event = BufRead,
    config = function()
      require("todo-comments").setup()
    end,
    disable = not O.plugin.todo_comments,
  }
  -- LSP Colors
  use {
    "folke/lsp-colors.nvim",
    event = BufRead,
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
    event = BufRead,
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
    config = function()
      require("lv-diffview").config()
    end,
    ft = "diff",
    module = "diffview",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
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
    -- event = BufRead,
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
  use {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("lv-vimtex").config()
    end,
    disable = not O.plugin.vimtex,
  }

  -- Rust tools
  use {
    "simrat39/rust-tools.nvim",
    config = function()
      require("lv-rust-tools").setup()
    end,
    ft = "rust",
    disable = not O.plugin.rust_tools,
  }
  use {
    "saecki/crates.nvim",
    config = function()
      require("lv-rust-tools").crates_setup()
    end,
    event = "BufRead Cargo.toml",
  }

  -- TODO: configure package-info.nvim
  use {
    "vuki656/package-info.nvim",
    config = function()
      require("lv-package-info").setup()
    end,
    event = "BufRead package.json",
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
  use {
    "IndianBoy42/tree-sitter-just",
    config = function()
      require("tree-sitter-just").setup { ["local"] = true }
    end,
  }

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

  -- Code action lightbulb
  use {
    "kosayoda/nvim-lightbulb",
    config = function()
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end,
    event = { "CursorHold", "CursorHoldI" },
    disable = not O.plugin.lightbulb,
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
    event = BufRead,
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
    event = BufRead,
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
    disable = not O.plugin.surround,
  }

  -- fzf based search
  use { "junegunn/fzf", disable = not O.plugin.fzf } -- Telescope does most of this?
  use { "junegunn/fzf.vim", disable = not O.plugin.fzf }

  -- Run commands async
  -- use {"skywind3000/asyncrun.vim"}
  -- Build cmake projects from neovim
  -- use {"Shatur95/neovim-cmake"}

  -- Send to jupyter
  use {
    "dccsillag/magma-nvim",
    config = function()
      require("lv-terms").magma()
    end,
    setup = function()
      vim.g.magma_automatically_open_output = not not O.plugin.magma.automatically_open_output
    end,
    run = ":UpdateRemotePlugins",
    -- python3.9 -m pip install cairosvg pnglatex jupyter_client ipython ueberzug pillow
    cmd = "MagmaStart", -- see lv-terms
    disable = not O.plugin.magma,
  }
  -- Better neovim terminal
  use {
    "kassio/neoterm",
    config = function()
      require("lv-terms").neoterm()
    end,
    cmd = {
      "T",
      "Tmap",
      "Tnew",
      "Ttoggle",
      "Topen",
    },
    keys = {
      "<Plug>(neoterm-repl-send)",
      "<Plug>(neoterm-repl-send-line)",
      "<Plug>(neoterm-repl-send)",
    },
    disable = not O.plugin.neoterm,
  }
  -- Lua development helper
  use {
    "bfredl/nvim-luadev",
    config = function()
      require("lv-terms").luadev()
    end,
    cmd = "LuadevStart", -- see lv-terms
    disable = not O.plugin.luadev,
  }
  use {
    "rafcamlet/nvim-luapad",
    cmd = { "Luapad", "LuaRun" },
    disable = not O.plugin.luapad,
  }
  -- TODO: try these code running plugins
  -- https://github.com/CRAG666/code_runner.nvim
  use {
    "IndianBoy42/code_runner.nvim",
    config = function()
      require("lv-terms").coderunner()
    end,
    cmd = { "CRFileType", "CRProjects", "RunCode", "RunFile", "RunProject" },
    disable = not O.plugin.coderunner,
  }
  use {
    "michaelb/sniprun",
    run = "bash install.sh",
    config = function()
      require("lv-terms").sniprun()
    end,
    cmd = { "SnipRun", "SnipInfo" },
    disable = not O.plugin.sniprun,
  }
  use {
    "IndianBoy42/kitty-runner.nvim",
    config = function()
      require("lv-terms").kitty()
    end,
    cmd = {
      "KittyOpen",
      "KittyOpenLocal",
      "KittyReRunCommand",
      "KittySendLines",
      "KittyRunCommand",
      "KittyClearRunner",
      "KittyKillRunner",
    },
    disable = not O.plugin.kittyrunner,
  }

  -- Repeat plugin commands
  use { "tpope/vim-repeat", event = BufRead }

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

  -- Detect indentation from file -- SLOW AF
  -- use { "zsugabubus/crazy8.nvim", event = BufRead }

  -- mkdir
  use {
    "jghauser/mkdir.nvim",
    config = function()
      require "mkdir"
    end,
  }

  -- Sudo write files
  use { "lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead" } }

  -- Helper for lists
  -- FIXME: fucks up coq_nvim handling of <CR>
  use {
    "dkarter/bullets.vim",
    ft = { "txt", "markdown" }, -- TODO: what filetypes?
    disable = not O.plugin.bullets,
  }
  -- Render latex math as ASCII (FIXME: doesn't seem to work??)
  use { "jbyuki/nabla.nvim", module = "nabla", disable = not O.plugin.nabla }

  -- 'smooth' scrolling
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup(O.plugin.neoscroll)
    end,
    disable = not O.plugin.neoscroll,
  }

  -- Code Minimap
  -- use {
  --   "wfxr/minimap.vim",
  --   cmd = "MinimapToggle",
  --   run = "cargo install --locked code-minimap",
  --   config = function()
  --     table.insert(vim.g.minimap_block_filetypes, "dashboard")
  --     vim.g.minimap_width = 5 -- Like a scrollbar
  --     -- vim.g.minimap_highlight_search = true
  --     -- vim.g.minimap_highlight_range = true
  --   end,
  -- }
  use {
    "rinx/nvim-minimap",
    setup = function()
      vim.g["minimap#window#width"] = 5
      vim.g["minimap#window#height"] = 10000
    end,
    cmd = "MinimapToggle",
  }

  -- Session Management
  use { "rmagatti/auto-session" }
  use {
    "rmagatti/session-lens",
    requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    config = function()
      require("session-lens").setup {--[[your custom config--]]
      }
      require("telescope").load_extension "session-lens"
    end,
    cmd = "SearchSession",
  }
  -- https://github.com/tpope/vim-obsession

  -- treesitter extensions
  use {
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    "jacfger/nvim-treesitter-textobjects",
    disable = not O.plugin.ts_textobjects,
  }
  use {
    "Jason-M-Chan/ts-textobjects",
    disable = not O.plugin.ts_textobjects,
  }
  use {
    "RRethy/nvim-treesitter-textsubjects",
    disable = not O.plugin.ts_textsubjects,
  }
  use {
    "David-Kunz/treesitter-unit",
    config = function()
      vim.api.nvim_set_keymap("v", "x", '<cmd>lua require"treesitter-unit".select()<CR>', { noremap = true })
      vim.api.nvim_set_keymap("o", "x", '<cmd><c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
    end,
    disable = not O.plugin.ts_textunits,
  }
  use {
    "mfussenegger/nvim-ts-hint-textobject",
    config = function()
      local labels = {}
      O.hint_labels:gsub(".", function(c)
        vim.list_extend(labels, { c })
      end)
      require("tsht").config.hint_keys = labels -- Requires https://github.com/mfussenegger/nvim-ts-hint-textobject/pull/2

      -- mappings.sile("o", "m", [[:<C-U>lua require('tsht').nodes()<CR>]])
    end,
    module = "tsht",
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
  use {
    "windwp/nvim-ts-autotag",
    event = BufRead,
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
    "dstein64/vim-startuptime",
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
    event = BufRead,
    config = function()
      require("anywise_reg").setup(O.plugin.anywise_reg)
    end,
    disable = not O.plugin.anywise_reg,
  }

  -- Editorconfig support
  use {
    "editorconfig/editorconfig-vim",
    event = BufRead,
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
    keys = { "gs", "gj" },
  }

  use {
    "Iron-E/nvim-libmodal",
    config = function()
      require("keymappings").libmodal_setup()
    end,
  }
  -- use { "Iron-E/nvim-tabmode", after = "nvim-libmodal" }

  use { "ellisonleao/glow.nvim", run = ":GlowInstall", cmd = "Glow" }

  -- Command line autocomplete
  use {
    "gelguy/wilder.nvim",
    config = function()
      require("lv-wilder").config()
    end,
    run = ":UpdateRemotePlugins",
    -- event = "CmdlineEnter",
  }

  -- Primeagens refactoring plugin
  use {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("lv-refactoring").setup()
    end,
    disable = not O.plugin.primeagen_refactoring,
  }

  -- Lowlight code outside the current context
  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {}
    end,
    cmd = "Twilight",
    disable = not O.plugin.twilight,
  }
  -- Zen Mode
  use {
    "Pocco81/TrueZen.nvim",
    cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
    config = function()
      require("lv-zen").config()
    end,
    disable = not O.plugin.zen,
  }
  -- Auto split management
  use {
    "beauwilliams/focus.nvim",
    config = function()
      local focus = require "focus"
      local conf = O.plugin.splitfocus
      focus.setup {
        winhighlight = conf.winhighlight,
        hybridnumber = conf.hybridnumber,
        relativenumber = conf.relative_number == nil and O.relative_number or conf.relative_number,
        number = conf.number == nil and O.number or conf.number,
        cursorline = conf.cursorline == nil and O.cursorline or conf.cursorline,
        signcolumn = conf.signcolumn,
      }
    end,
    cmd = "FocusSplitNicely",
    module = "focus",
    disable = not O.plugin.splitfocus,
  }

  -- Unix style vim commands
  use {
    "tpope/vim-eunuch",
    event = "BufRead",
    cmd = {
      "Delete",
      "Unlink",
      "Move",
      "Rename",
      "Chmod",
      "Mkdir",
      "Cfind",
      "Clocate",
      "Lfind",
      "Wall",
      "SudoWrite",
      "SudoEdit",
    },
  }

  -- Orgmode clone
  use {
    "vhyrro/neorg",
    config = function()
      require("neorg").setup {
        -- Tell Neorg what modules to load
        load = {
          ["core.defaults"] = {}, -- Load all the default modules
          ["core.norg.concealer"] = {}, -- Allows for use of icons
          ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
              workspaces = {
                my_workspace = "~/neorg",
              },
            },
          },
        },
      }
    end,
    ft = "norg",
    requires = "nvim-lua/plenary.nvim",
    disable = not O.plugin.neorg,
  }

  use {
    "notomo/gesture.nvim",
    config = function()
      require("lv-gestures").config()
    end,
    module = "gesture",
    disable = not O.plugin.gesture,
  }

  -- TODO: add and configure these packages
  -- Git
  use {
    "tpope/vim-fugitive",
    config = function()
      require("lv-fugitive").setup()
    end,
    cmd = { "G", "Git", "Gdiffsplit", "Gdiff" },
    disable = not O.plugin.fugitive,
  }
  -- use { "tpope/vim-rhubarb" }

  -- TODO: http://neovimcraft.com/plugin/chipsenkbeil/distant.nvim/index.html
  use {
    "chipsenkbeil/distant.nvim",
    config = function()
      require("lv-distant").config()
    end,
    cmd = "DistantLaunch",
  }
  -- TODO: https://github.com/jbyuki/instant.nvim (collaborative editing)
  use {
    "jbyuki/instant.nvim",
    cmd = {
      "InstantStartServer",
      "InstantStartSingle",
      "InstalJoinSingle",
      "InstantStartSession",
      "InstantJoinSession",
    },
  }

  -- Colorschemes/Themes
  -- Lush - Create Color Schemes
  use {
    "rktjmp/lush.nvim",
    cmd = { "LushRunQuickstart", "LushRunTutorial", "Lushify" },
    disable = not O.plugin.lush,
  }
  -- Colorbuddy colorscheme helper
  use { "tjdevries/colorbuddy.vim", module = "colorbuddy" }
  -- Colorschemes -- https://github.com/folke/lsp-colors.nvim
  use { "Yagua/nebulous.nvim" }
  use { "christianchiarulli/nvcode-color-schemes.vim", opt = true }
  use {
    "Pocco81/Catppuccino.nvim",
    config = function()
      local trues = setmetatable({
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = "italic",
            hints = "italic",
            warnings = "italic",
            information = "italic",
          },
          underlines = {
            errors = "underline",
            hints = "underline",
            warnings = "underline",
            information = "underline",
          },
        },
        nvimtree = {
          enabled = true,
          show_root = true,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
      }, { -- Return always true
        __index = function(tbl, key)
          return true
        end,
      })
      require("catppuccino").setup {
        colorscheme = "dark_catppuccino", -- neon_latte
        styles = {
          comments = "italic",
          functions = "NONE",
          keywords = "italic",
          strings = "NONE",
          variables = "NONE",
        },
        integrations = trues,
      }
    end,
  }
  use "mcchrish/zenbones.nvim"
  use "plan9-for-vimspace/acme-colors"
  use "preservim/vim-colors-pencil"
  use "YorickPeterse/vim-paper"
  use "ajgrf/parchment"
  use "pgdouyon/vim-yin-yang"
  -- use {
  --   "sainnhe/sonokai",
  --   config = function()
  --     vim.g.sonokai_style = "atlantis" -- andromeda
  --   end,
  -- }
  -- use "tanvirtin/monokai.nvim"
  -- use "RishabhRD/nvim-rdark"
  -- use "marko-cerovac/material.nvim"
  -- use "Shatur/neovim-ayu"
  -- use "folke/tokyonight.nvim"
  -- use "Mofiqul/dracula.nvim"
  -- use "tomasiser/vim-code-dark"
  -- use "glepnir/zephyr-nvim"
  -- use "Th3Whit3Wolf/onebuddy" -- require('colorbuddy').colorscheme('onebuddy')
  use "ishan9299/modus-theme-vim"
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
  -- use {
  --   "adisen99/codeschool.nvim",
  --   config = function()
  -- local trues = setmetatable({}, { -- Return always true
  --   __index = function(tbl, key)
  --     return  true
  --   end,
  -- })
  --     require("codeschool").setup {
  --       plugins = trues,
  --       langs = trues,
  --     }
  --   end,
  --   requires = { "rktjmp/lush.nvim" },
  -- }

  -- https://github.com/rockerBOO/awesome-neovim -- collection

  -- alt nvim ide
  -- https://github.com/ibhagwan/nvim-lua
  -- https://github.com/lvim-tech/lvim
  -- https://github.com/NTBBloodbath/doom-nvim
  -- https://github.com/MenkeTechnologies/zpwr#zpwr-features

  -- Plugins
  -- https://github.com/kevinhwang91/nvim-hlslens
  -- use { "vim-scripts/tar.vim" }
  -- https://github.com/neomake/neomake
  -- https://github.com/justinmk/vim-dirvish -- netrw/nvim-tree alternative

  -- local metatable = {
  --   __newindex = function(table, repo, options)
  --     options[1] = table[1] .. "/" .. repo
  --     use(options)
  --   end,
  -- }
  -- local plugins_table = setmetatable({}, {
  --   __index = function(table, user)
  --     return setmetatable({ user }, metatable)
  --   end,
  -- })
  -- plugins_table.gelguy["wilder.nvim"] = {
  --   config = function()
  --     require("lv-wilder").config()
  --   end,
  -- }

  use { "seandewar/nvimesweeper", cmd = "Nvimesweeper" }
end)
