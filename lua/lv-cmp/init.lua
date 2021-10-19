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
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "path" },
  -- { name = "latex_symbols" },
  { name = "calc" },
  -- { name = "cmp_tabnine" },
}
function M.sources(list)
  require("cmp").setup.buffer(list)
end
function M.add_sources(list)
  M.sources(vim.list_extend(list, default_sources))
end
function M.setup()
  local cmp = require "cmp"
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
    end)
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
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      -- ["<C-p>"] = cmp.mapping.select_prev_item(),
      -- ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<esc>"] = cmp.mapping.close(),
      ["<C-p>"] = complete_or(cmp.select_prev_item),
      ["<C-n>"] = complete_or(cmp.select_next_item),
      ["<M-h>"] = cmp.mapping.close(),
      ["<M-j>"] = complete_or(cmp.select_prev_item),
      ["<M-k>"] = complete_or(cmp.select_next_item),
      ["<M-l>"] = complete_or(cmp.confirm),
      ["<Left>"] = cmp.mapping.confirm(confirmopts),
      ["<Right>"] = cmp.mapping.confirm(confirmopts),
      ["<CR>"] = cmp.mapping.confirm(confirmopts),
      ["<tab>"] = cmp.mapping(function(fallback)
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
      end, {
        "i",
        "s",
      }),
      ["<S-tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- feedkeys(t "<C-p>", "n", false)
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          feedkeys(t "<Plug>luasnip-jump-prev", "", false)
        else
          feedkeys(t "<Plug>(TaboutBack)", "", false)
          -- fallback()
        end
      end, {
        "i",
        "s",
      }),
    },

    -- You should specify your *installed* sources.
    sources = default_sources,

    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
        -- set a name for each source
        vim_item.menu = iconmap[entry.source.name]
        return vim_item
      end,
    },
  }
end

return M
