local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " ..
                install_path)
    execute "packadd packer.nvim"
end

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then return end

packer.init {
    -- compile_path = vim.fn.stdpath('data')..'/site/pack/loader/start/packer.nvim/plugin/packer_compiled.vim',
    git = {clone_timeout = 300}
    -- display = {
    --   -- open_fn = function()
    --   --   return require("packer.util").float { border = "single" }
    --   -- end,
    -- },
}

--- Check if a file or directory exists in this path
local function require_plugin(plugin)
    local plugin_prefix = fn.stdpath("data") .. "/site/pack/packer/opt/"

    local plugin_path = plugin_prefix .. plugin .. "/"
    --	print('test '..plugin_path)
    local ok, err, code = os.rename(plugin_path, plugin_path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    --	print(ok, err, code)
    if ok then vim.cmd("packadd " .. plugin) end
    return ok, err, code
end

vim.cmd "autocmd BufWritePost plugins.lua luafile %" -- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost lv-config.lua luafile %" -- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost plugins.lua PackerSync" -- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost lv-config.lua PackerSync" -- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost plugins.lua PackerCompile" -- Auto compile when there are changes in plugins.lua
vim.cmd "autocmd BufWritePost lv-config.lua PackerCompile" -- Auto compile when there are changes in plugins.lua

return require("packer").startup(function(use)
    -- Packer can manage itself as an optional plugin
    use "wbthomason/packer.nvim"

    -- TODO refactor all of this (for now it works, but yes I know it could be wrapped in a simpler function)
    use {"neovim/nvim-lspconfig"}
    use {"glepnir/lspsaga.nvim"}
    use {
        "kabouzeid/nvim-lspinstall",
        config = function()
            require('lv-lspinstall')
        end
    }
    -- Telescope
    use {"nvim-lua/popup.nvim"}
    use {"nvim-lua/plenary.nvim"}
    use {"tjdevries/astronauta.nvim"}
    -- Telescope - search through things
    use {
        "nvim-telescope/telescope.nvim",
        config = [[require('lv-telescope')]],
        cmd = "Telescope"
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
        end
    }

    -- VSCode style snippets
    use {"hrsh7th/vim-vsnip", event = "InsertEnter"}
    use {"rafamadriz/friendly-snippets", event = "InsertEnter"}

    -- Treesitter
    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

    use {
        "kyazdani42/nvim-tree.lua",
        cmd = "NvimTreeToggle",
        config = function()
            require("lv-nvimtree").config()
        end
    }

    use {
        "lewis6991/gitsigns.nvim",

        config = function()
            require("lv-gitsigns").config()
        end,
        event = "BufRead"
    }

    -- whichkey
    use {
        "folke/which-key.nvim",
        config = function()
            require('lv-which-key').config()
        end
    }

    -- Autopairs
    use {
        "windwp/nvim-autopairs",
        config = function()
            require 'lv-autopairs'
        end
    }

    -- Comments
    use {
        "terrortylor/nvim-comment",
        event = "BufRead",
        config = function()
            require('nvim_comment').setup()
        end
    }

    -- Color
    use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}

    -- Icons
    use {"kyazdani42/nvim-web-devicons"}

    -- Status Line and Bufferline
    use {"glepnir/galaxyline.nvim"}

    use {
        "romgrk/barbar.nvim",

        config = function()
            vim.api.nvim_set_keymap('n', '<TAB>', ':BufferNext<CR>',
                                    {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious<CR>',
                                    {noremap = true, silent = true})
            vim.api.nvim_set_keymap('n', '<S-x>', ':BufferClose<CR>',
                                    {noremap = true, silent = true})
        end,
        event = "BufRead"

    }

    -- Extras, these do not load by default

    -- Better motions
    use {
        'phaazon/hop.nvim',
        event = 'BufRead',
        config = function()
            require('lv-hop').config()
        end,
        disable = not O.plugin.hop.active,
        opt = true
    }
    -- Enhanced increment/decrement
    use {
        'monaqa/dial.nvim',
        event = 'BufRead',
        config = function()
            require('lv-dial').config()
        end,
        disable = not O.plugin.dial.active,
        opt = true
    }
    -- Dashboard
    use {
        "ChristianChiarulli/dashboard-nvim",
        event = 'BufWinEnter',
        cmd = {"Dashboard", "DashboardNewFile", "DashboardJumpMarks"},
        config = function()
            require('lv-dashboard').config()
        end,
        disable = not O.plugin.dashboard.active,
        opt = true
    }
    -- Zen Mode
    use {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        -- event = "BufRead",
        config = function()
            require('lv-zen').config()
        end,
        disable = not O.plugin.zen.active
    }
    -- Ranger
    use {
        "kevinhwang91/rnvimr",
        cmd = "Rnvimr",
        config = function()
            require('lv-rnvimr').config()
        end,
        disable = not O.plugin.ranger.active
    }

    -- matchup
    use {
        'andymass/vim-matchup',
        event = "CursorMoved",
        config = function()
            require('lv-matchup').config()
        end,
        disable = not O.plugin.matchup.active
    }

    use {
        "norcalli/nvim-colorizer.lua",
        event = "BufRead",
        config = function()
            require("colorizer").setup()
            vim.cmd("ColorizerReloadAllBuffers")
        end,
        disable = not O.plugin.colorizer.active
    }

    use {
        "nacro90/numb.nvim",
        event = "BufRead",
        config = function()
            require('numb').setup {
                show_numbers = true, -- Enable 'number' for the window while peeking
                show_cursorline = true -- Enable 'cursorline' for the window while peeking
            }
        end,
        disable = not O.plugin.numb.active
    }

    -- Treesitter playground
    use {
        'nvim-treesitter/playground',
        event = "BufRead",
        disable = not O.plugin.ts_playground.active
    }

    use {
        "lukas-reineke/indent-blankline.nvim",
        branch = "lua",
        event = "BufRead",
        setup = function()

            vim.g.indentLine_enabled = 1
            vim.g.indent_blankline_char = "▏"

            vim.g.indent_blankline_filetype_exclude = {
                "help", "terminal", "dashboard"
            }
            vim.g.indent_blankline_buftype_exclude = {"terminal"}

            vim.g.indent_blankline_show_trailing_blankline_indent = false
            vim.g.indent_blankline_show_first_indent_level = true
        end,
        disable = not O.plugin.indent_line.active
    }

    -- comments in context
    use {
        'JoosepAlviste/nvim-ts-context-commentstring',
        event = "BufRead",
        disable = not O.plugin.ts_context_commentstring.active
    }

    -- Symbol Outline
    use {
        'simrat39/symbols-outline.nvim',
        cmd = 'SymbolsOutline',
        disable = not O.plugin.symbol_outline.active
    }
    -- diagnostics
    use {
        "folke/trouble.nvim",
        cmd = 'TroubleToggle',
        disable = not O.plugin.trouble.active,
        config = function()
            -- TODO: move this to a separate file
            vim.cmd([[
            autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * TroubleRefresh
            ]])

            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                position = "right",
                auto_preview = false,
                hover = "h"
            }
        end
    }
    -- Debugging
    use {
        "mfussenegger/nvim-dap",
        event = "BufRead",
        disable = not O.plugin.debug.active
    }
    -- Better quickfix
    use {
        "kevinhwang91/nvim-bqf",
        event = "BufRead",
        disable = not O.plugin.bqf.active
    }
    -- Floating terminal
    use {
        'numToStr/FTerm.nvim',
        event = "BufRead",
        config = function()
            require'FTerm'.setup({
                dimensions = {height = 0.8, width = 0.8, x = 0.5, y = 0.5},
                border = 'single' -- or 'double'
            })
            require('fterms')
        end,
        disable = not O.plugin.floatterm.active
    }
    -- Search & Replace
    use {
        'windwp/nvim-spectre',
        event = "BufRead",
        config = function()
            require('spectre').setup()
        end,
        disable = not O.plugin.spectre.active
    }
    -- lsp root with this nvim-tree will follow you
    use {
        "ahmedkhalf/lsp-rooter.nvim",
        event = "BufRead",
        config = function()
            require("lsp-rooter").setup()
        end,
        disable = not O.plugin.lsp_rooter.active
    }
    -- Markdown preview
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && npm install',
        ft = 'markdown',
        disable = not O.plugin.markdown_preview.active
    }
    -- Interactive scratchpad
    use {
        'metakirby5/codi.vim',
        cmd = 'Codi',
        disable = not O.plugin.codi.active
    }
    -- Use fzy for telescope
    use {
        "nvim-telescope/telescope-fzy-native.nvim",
        event = "BufRead",
        after = "telescope.nvim",
        disable = not O.plugin.telescope_fzy.active
    }
    -- Use project for telescope
    use {
        "nvim-telescope/telescope-project.nvim",
        event = "BufRead",
        after = "telescope.nvim",
        disable = not O.plugin.telescope_project.active
    }
    -- Sane gx for netrw_gx bug
    use {
        "felipec/vim-sanegx",
        event = "BufRead",
        disable = not O.plugin.sanegx.active
    }
    -- Highlight TODO comments
    use {
        "folke/todo-comments.nvim",
        event = "BufRead",
        disable = not O.plugin.todo_comments.active
    }
    -- LSP Colors
    use {
        "folke/lsp-colors.nvim",
        event = "BufRead",
        disable = not O.plugin.lsp_colors.active
    }
    -- Git Blame
    use {
        "f-person/git-blame.nvim",
        event = "BufRead",
        disable = not O.plugin.git_blame.active
    }
    use {
        'ruifm/gitlinker.nvim',
        event = "BufRead",
        config = function()
            require"gitlinker".setup({
                opts = {
                    -- remote = 'github', -- force the use of a specific remote
                    -- adds current line nr in the url for normal mode
                    add_current_line_on_normal_mode = true,
                    -- callback for what to do with the url
                    action_callback = require"gitlinker.actions".open_in_browser,
                    -- print the url after performing the action
                    print_url = false,
                    -- mapping to call url generation
                    mappings = "<leader>gy"
                }
            })

        end,
        disable = not O.plugin.gitlinker.active,
        requires = 'nvim-lua/plenary.nvim'

    }
    -- Lazygit
    use {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        disable = not O.plugin.lazygit.active
    }
    -- Octo.nvim
    use {
        "pwntester/octo.nvim",
        event = "BufRead",
        disable = not O.plugin.octo.active
    }
    -- Diffview
    use {
        "sindrets/diffview.nvim",
        event = "BufRead",
        disable = not O.plugin.diffview.active
    }
    -- Easily Create Gists
    use {
        "mattn/vim-gist",
        event = "BufRead",
        disable = not O.plugin.gist.active,
        requires = 'mattn/webapi-vim'
    }
    -- Lush Create Color Schemes
    use {
        "rktjmp/lush.nvim",
        event = "VimEnter",
        -- cmd = {"LushRunQuickstart", "LushRunTutorial", "Lushify"},
        -- disable = not O.plugin.lush.active,
    }
    -- HTML preview
    use {
        'turbio/bracey.vim',
        event = "BufRead",
        run = 'npm install --prefix server',
        disable = not O.plugin.bracey.active
    }
    -- Debugger management
    use {
        'Pocco81/DAPInstall.nvim',
        event = "BufRead",
        disable = not O.plugin.dap_install.active
    }

    -- LANGUAGE SPECIFIC GOES HERE
    -- Latex 
    -- TODO what filetypes should this be active for?
    use {"lervag/vimtex", ft = "tex", disable = not O.lang.latex.active}

    -- Rust tools
    -- TODO: use lazy loading maybe?
    use {"simrat39/rust-tools.nvim", disable = not O.lang.rust.active}

    -- Elixir
    use {
        "elixir-editors/vim-elixir",
        ft = {"elixir", "eelixir"},
        disable = not O.lang.elixir.active
    }

    -- amedhi plugins

    use {"unblevable/quick-scope", opt = true}
    require_plugin("quick-scope")
    use {"justinmk/vim-sneak", opt = true}
    require_plugin("vim-sneak")
    -- use {"wellle/targets.vim", opt = true}
    -- require_plugin("targets.vim")
    use {"mg979/vim-visual-multi", opt = true}
    require_plugin("vim-visual-multi")
    -- use {"tpope/vim-surround", opt = true}
    -- require_plugin("vim-surround")
    use {"machakann/vim-sandwich"}
    use {"junegunn/fzf", opt = true} -- Telescope does most of this?
    use {"junegunn/fzf.vim", opt = true}
    require_plugin("fzf")
    require_plugin("fzf.vim")
    use {"skywind3000/asyncrun.vim", opt = true}
    require_plugin("asyncrun.vim")
    use {"Shatur95/neovim-cmake", opt = true}
    require_plugin("neovim-cmake")
    -- use {"SirVer/ultisnips", opt = true}
    -- require_plugin("ultisnips")
    use {"jpalardy/vim-slime", opt = true}
    require_plugin("vim-slime")
    -- https://github.com/tpope/vim-repeat
    use {"dag/vim-fish", opt = true}
    require_plugin("vim-fish")
    use {"kmonad/kmonad-vim", opt = true}
    require_plugin("kmonad-vim")
    use {"lambdalisue/suda.vim", opt = true}
    require_plugin("suda.vim")
    use {"liuchengxu/vista.vim", opt = true}
    require_plugin("vista.vim")
    use "NoahTheDuke/vim-just"
    -- use 'karb94/neoscroll.nvim'

    -- lsp extensions
    use {"nvim-lua/lsp_extensions.nvim", opt = true}
    require_plugin("lsp_extensions.nvim")
    -- use {"nvim-lua/completion-nvim", opt = true}
    -- require_plugin("completion-nvim")
    use "ray-x/lsp_signature.nvim"

    -- treesitter extensions
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "RRethy/nvim-treesitter-textsubjects"
    use {"windwp/nvim-ts-autotag"}

    -- mkdir
    use {
        'jghauser/mkdir.nvim',
        config = function()
            require('mkdir')
        end
    }

    -- Colorschemes
    -- use {'Mofiqul/dracula.nvim'}
    use {'marko-cerovac/material.nvim'}
    use {'folke/tokyonight.nvim'}
    -- use {'tomasiser/vim-code-dark'}

    -- use {'mattn/webapi-vim', opt = true}
    --     use {'f-person/git-blame.nvim', opt = true}
    --     -- diagnostics
    --     use {"folke/trouble.nvim", opt = true}
    --     -- Debugging
    --     use {"mfussenegger/nvim-dap", opt = true}
    --     -- Better quickfix
    --     use {"kevinhwang91/nvim-bqf", opt = true}
    --     -- Search & Replace
    --     use {'windwp/nvim-spectre', opt = true}
    --     -- Symbol Outline
    --     use {'simrat39/symbols-outline.nvim', opt = true}
    --     -- Interactive scratchpad
    --     use {'metakirby5/codi.vim', opt = true}
    --     -- Markdown preview
    --     use {
    --         'iamcco/markdown-preview.nvim',
    --         run = 'cd app && npm install',
    --         opt = true
    --     }
    --     require_plugin('markdown-preview.nvim')
    --
    --
    --     -- Sane gx for netrw_gx bug
    --     use {"felipec/vim-sanegx", opt = true}
    -- lsp root
    -- use {"ahmedkhalf/lsp-rooter.nvim", opt = true} -- with this nvim-tree will follow you
    -- require_plugin('lsp-rooter.nvim')

    -- folke/todo-comments.nvim
    -- gennaro-tedesco/nvim-jqx
    -- TimUntersberger/neogit
    -- folke/lsp-colors.nvim
    -- simrat39/symbols-outline.nvim

    -- Git
    -- use {'tpope/vim-fugitive', opt = true}
    -- use {'tpope/vim-rhubarb', opt = true}
    -- pwntester/octo.nvim

    -- Easily Create Gists
    -- use {'mattn/vim-gist', opt = true}
    -- use {'mattn/webapi-vim', opt = true}

end)
