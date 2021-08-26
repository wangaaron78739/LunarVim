local M = {}
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
    },
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
      ["<tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(t "<C-n>", "n")
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(t "<Plug>luasnip-expand-or-jump", "")
        elseif check_back_space() then
          vim.fn.feedkeys(t "<tab>", "n")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(t "<C-p>", "n")
        elseif luasnip.jumpable(-1) then
          vim.fn.feedkeys(t "<Plug>luasnip-jump-prev", "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
    },

    -- You should specify your *installed* sources.
    sources = {
      { name = "buffer" },
      { name = "path" },
      { name = "latex_symbols" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
    },

    formatting = {
      format = function(entry, vim_item)
        -- fancy icons and a name of kind
        vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
        -- set a name for each source
        vim_item.menu = ({
          buffer = "   [Buffer]",
          path = "   [Path]",
          nvim_lsp = "   [LSP]",
          luasnip = "   [Snippet]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
          calc = "   [Calc]",
        })[entry.source.name]
        return vim_item
      end,
    },
  }
end

return M
