local M = {}

M.config = function()
  local hop = require "hop"
  hop.setup {
    keys = O.hint_labels,
  }
end

M.current_line_words = function()
  require("hop").hint_words {
    opts = {
      direction = require("hop.constants").HintDirection.CURRENT_LINE,
    },
  }
end

M.keymaps = function()
  if O.plugin.hop then
    -- TODO: register_nN_repeat here??
    local prefix = "<cmd>lua require('hop')."
    local hops = {
      name = "Hop",
      w = { prefix .. "hint_words()<cr>", "Words" },
      l = { prefix .. "hint_lines_skip_whitespace()<cr>", "Lines" },
      L = { prefix .. "hint_lines(nil, true)<cr>", "Lines" },
      ["*"] = { prefix .. "hint_cword()<cr>", "cword" },
      W = { prefix .. "hint_cWORD()<cr>", "cWORD" },
      h = { prefix .. "hint_locals()<cr>", "Locals" },
      d = { prefix .. "hint_definitions()<cr>", "Definitions" },
      r = { prefix .. "hint_references()<cr>", "References" },
      u = { prefix .. "hint_references(nil, '<cword>')<cr>", "Usages" },
      s = { prefix .. "hint_scopes()<cr>", "Scopes" },
      t = { prefix .. "hint_textobjects()<cr>", "Textobjects" },
      b = { "<cmd>lua require'lv-hop.lsp'.hop_symbols()<cr>", "LSP Symbols" },
      g = { "<cmd>lua require'lv-hop.lsp'.hop_diagnostics()<cr>", "LSP Diagnostics" },
      -- f = { prefix .. "hint_textobjects{query='function'}<cr>", "Functions" },
      -- a = { prefix .. "hint_textobjects{query='parameter'}<cr>", "parameter" },
    }
    for k, v in pairs(O.treesitter.textobj_suffixes) do
      hops[v[1]] = hops[v[1]] or { prefix .. "hint_textobjects{query='" .. k .. "'}<cr>", "@" .. k }
    end
    require("which-key").register(hops, {
      mode = "n",
      prefix = "<leader>h",
      silent = true,
    })
  end
end

return M
