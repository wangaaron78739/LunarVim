local M = {}
M.config = function()
  vim.ui.input = function(opts, on_confirm)
    opts = opts or {}
    -- opts.completion
    -- opts.highlight
    require("lv-utils").inline_text_input {
      border = O.lsp.rename_border,
      enter = on_confirm,
      init_cword = opts.default or opts.prompt,
      at_begin = true,
      minwidth = true,
    }
  end
end
return M
