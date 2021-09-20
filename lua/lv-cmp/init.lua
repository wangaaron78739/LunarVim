local M = {}
local iconmap = {
  buffer = "   [Buffer]",
  path = "   [Path]",
  nvim_lsp = "   [LSP]",
  -- luasnip = "   [Snippet]",
  luasnip = "",
  nvim_lua = "[Lua]",
  latex_symbols = "[Latex]",
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
  local check_back_space = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s" ~= nil
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
    -- experimental = { ghost_text = true },

    documentation = {
      border = "single",
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    },

    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.close(),
      ["<M-l>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.api.nvim_feedkeys(t "<C-l>", "m", false) -- confirm
        else
          vim.api.nvim_feedkeys(t "<C-space>", "m", false) -- complete
        end
      end),
      ["<C-space>"] = cmp.mapping.complete(),
      ["<C-l>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      ["<tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.api.nvim_feedkeys(t "<C-n>", "n", false)
        elseif luasnip.expand_or_jumpable() then
          vim.api.nvim_feedkeys(t "<Plug>luasnip-expand-or-jump", "", false)
        elseif check_back_space() then
          vim.api.nvim_feedkeys(t "<tab>", "n", false)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.api.nvim_feedkeys(t "<C-p>", "n", false)
        elseif luasnip.jumpable(-1) then
          vim.api.nvim_feedkeys(t "<Plug>luasnip-jump-prev", "", false)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      },
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
