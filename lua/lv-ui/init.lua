local M = {}
function M.config()
  require'lv-ui.popui'.config()
  vim.ui.input = function(opts, on_confirm)
    opts = opts or {}
    -- opts.completion
    -- opts.highlight

    require("lv-ui.input").inline_text_input {
      prompt = opts.prompt,
      border = O.input_border,
      enter = on_confirm,
      initial = opts.default,
      at_begin = false,
      minwidth = 20,
      insert = true,
    }
  end
end
return M
