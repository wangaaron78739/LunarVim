local M = {}
local texsym, _ = require("nvim-web-devicons").get_icon("main.tex", "tex")
local iconmap = {
  buffer = "   [Buffer]",
  path = "   [Path]",
  nvim_lsp = "   [LSP]",
  -- luasnip = "   [Luasnip]",
  spell = "暈[Spell]",
  nvim_lua = " [Lua]",
  latex_symbols = texsym .. " [Latex]",
  calc = "   [Calc]",
}
local default_sources = {
  {
    { name = "luasnip" },
    { name = "nvim_lsp" },
  },
  {
    { name = "buffer" },
    { name = "path" },
    -- { name = "latex_symbols" },
    { name = "calc" },
    -- { name = "cmp_tabnine" },
  },
}
function M.sources(list)
  local cmp = require "cmp"
  cmp.setup.buffer { sources = cmp.config.sources(list) }
end
function M.autocomplete(enable)
  require("cmp").setup.buffer { completion = { autocomplete = enable } }
end
function M.add_sources(list)
  M.sources(vim.list_extend(list, default_sources))
end
function M.setup()
  local cmp = require "cmp"
  local lspkind = require "lspkind"
  local luasnip = require "luasnip"

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end
  local feedkeys = vim.api.nvim_feedkeys
  local check_back_space = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
  end

  local confirmopts = {
    select = false,
  }

  local function double_mapping(invisible, visible)
    return cmp.mapping(function()
      if cmp.visible() then
        visible()
      else
        invisible()
      end
    end, {
      "i",
      "s",
      "c",
    })
  end
  local function complete_or(mapping)
    return double_mapping(cmp.complete, mapping)
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
      -- autocomplete = false,
    },
    preselect = cmp.PreselectMode.None,
    -- confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
    experimental = { ghost_text = true },

    documentation = {
      border = "single",
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    },

    mapping = {
      ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      -- ["<C-p>"] = cmp.mapping.select_prev_item(),
      -- ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = complete_or(cmp.select_prev_item),
      ["<C-n>"] = complete_or(cmp.select_next_item),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { "i", "c" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { "i", "c" }),
      ["<M-j>"] = complete_or(cmp.select_next_item),
      ["<M-k>"] = complete_or(cmp.select_prev_item),
      ["<M-l>"] = complete_or(cmp.confirm),
      ["<M-h>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
      ["<esc>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
      -- ["<Left>"] = cmp.mapping.close(confirmopts),
      ["<Right>"] = cmp.mapping {
        c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false },
      },
      ["<CR>"] = cmp.mapping {
        i = cmp.mapping.confirm(confirmopts),
        -- c = function(fallback)
        --   if cmp.visible() then
        --     cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        --   else
        --     fallback()
        --   end
        -- end,
      },
      ["<tab>"] = cmp.mapping {
        c = function()
          if cmp.visible() then
            cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
          else
            cmp.complete()
          end
        end,
        i = function()
          if cmp.visible() then
            -- feedkeys(t "<C-n>", "n", false)
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            feedkeys(t "<Plug>luasnip-expand-or-jump", "", false)
          elseif check_back_space() then
            feedkeys(t "<tab>", "n", false)
          else
            feedkeys(t "<Plug>(Tabout)", "", false)
            -- fallback()
          end
        end,
      },
      ["<S-tab>"] = cmp.mapping {
        c = function()
          if cmp.visible() then
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
          else
            cmp.complete()
          end
        end,
        i = function()
          if cmp.visible() then
            -- feedkeys(t "<C-p>", "n", false)
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            feedkeys(t "<Plug>luasnip-jump-prev", "", false)
          else
            feedkeys(t "<Plug>(TaboutBack)", "", false)
            -- fallback()
          end
        end,
      },
    },

    -- You should specify your *installed* sources.
    sources = cmp.config.sources(default_sources),

    formatting = {
      format = lspkind.cmp_format(O.plugin.cmp.lspkind),
    },
    -- formatting = {
    --   format = function(entry, vim_item)
    --     -- fancy icons and a name of kind
    --     vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
    --     -- set a name for each source
    --     vim_item.menu = iconmap[entry.source.name]
    --     return vim_item
    --   end,
    -- },
  }

  -- Use buffer source for `/`.
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M
