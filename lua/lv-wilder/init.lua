local M = {}

M.wilder = setmetatable({}, {
  __index = function(mytable, key)
    return vim.fn["wilder#" .. key]
  end,
})
M.set_option = setmetatable({}, {
  __index = function(mytable, key)
    return function(opts)
      M.wilder.set_option(key, opts)
    end
  end,
  __newindex = function(table, key, value)
    M.wilder.set_option(key, value)
  end,
})
M.options = setmetatable({}, {
  __newindex = function(mytable, key, value)
    vim.cmd([[call wilder#set_option(']] .. key .. "', " .. value:gsub("\n", "") .. ")")
  end,
})

-- TODO: Convert to lua
function M.config()
  M.wilder.enable_cmdline_enter()

  M.set_option.modes = { "/", "?", ":" }

  vim.opt.wildcharm = vim.fn.char2nr "	" -- This is a <TAB>
  -- vim.api.nvim_replace_termcodes("<tab>", true, true, true)

  -- vim.api.nvim_set_keymap("c", "<F1>", "wilder#main#start()", { expr = true, silent = true })
  vim.api.nvim_set_keymap("c", "<Tab>", [[wilder#in_context() ? wilder#next() : "\<Tab>"]], { expr = true })
  vim.api.nvim_set_keymap("c", "<S-Tab>", [[wilder#in_context() ? wilder#previous() : "\<S-Tab>"]], { expr = true })

  M.options.pipeline = [[ 
  [ wilder#branch( wilder#cmdline_pipeline({ 'fuzzy': 1, }), wilder#python_search_pipeline({ 'pattern': 'fuzzy', }),), ] 
  ]]

  vim.g.wilder_highlighters = { M.wilder.pcre2_highlighter(), M.wilder.basic_highlighter() }

  M.options.renderer = [[
     wilder#renderer_mux({ 
       ':': wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter() }), 
       '/': wilder#wildmenu_renderer({ 'mode': 'statusline' }), 
     })
  ]]
end

return M
