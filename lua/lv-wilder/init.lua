local M = {}

local wilder = utils.fn.wilder
M.set_option = setmetatable({}, {
  __index = function(_, key)
    return function(opts)
      wilder.set_option(key, opts)
    end
  end,
  __newindex = function(_, key, value)
    wilder.set_option(key, value)
  end,
})
M.options = setmetatable({}, {
  __newindex = function(_, key, value)
    if not (type(value) == "string") then
      value = table.concat(value, ",")
    end
    vim.cmd([[call wilder#set_option(']] .. key .. "', " .. value:gsub("\n", "") .. ")")
  end,
})

-- TODO: Convert to lua
function M.config()
  wilder.main.enable_cmdline_enter()

  M.set_option.modes = { "/", "?", ":" }

  vim.opt.wildcharm = vim.fn.char2nr "	" -- This is a <TAB>
  -- vim.api.nvim_replace_termcodes("<tab>", true, true, true)

  -- vim.api.nvim_set_keymap("c", "<F1>", "wilder#main#start()", { expr = true, silent = true })
  vim.api.nvim_set_keymap("c", "<Tab>", [[wilder#in_context() ? wilder#next() : "\<Tab>"]], { expr = true })
  vim.api.nvim_set_keymap("c", "<S-Tab>", [[wilder#in_context() ? wilder#previous() : "\<S-Tab>"]], { expr = true })

  M.options.pipeline = {
    [[wilder#branch( wilder#cmdline_pipeline({ 'fuzzy': 1, }), wilder#python_search_pipeline({ 'pattern': 'fuzzy', }),), ]],
  }

  vim.g.wilder_highlighters = { wilder.pcre2_highlighter(), wilder.basic_highlighter() }

  M.options.renderer = [[ wilder#renderer_mux({ 
       ':': wilder#popupmenu_renderer({ 'highlighter': wilder#basic_highlighter() }), 
       '/': wilder#wildmenu_renderer({ 'mode': 'statusline' }), 
     }) ]]
end

M.wilder = wilder
return M
