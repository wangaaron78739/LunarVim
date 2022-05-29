local lsp_status = require "lsp-status"
lsp_status.register_progress()

local gps = require "nvim-gps"
gps.setup {
  icons = {
    ["class-name"] = " ", -- Classes and class-like objects
    ["function-name"] = " ", -- Functions
    ["method-name"] = " ", -- Methods (functions inside class-like objects)
  },
  -- Disable any languages individually over here
  -- Any language not disabled here is enabled by default
  languages = {},
  separator = " > ",
}

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" }, -- nvim is the new more general
  sections = { "error", "warn", "info", "hint" },
  symbols = { error = "E", warn = "W", info = "I", hint = "H" },
}
local filename = {
  "filename",
  file_status = true, -- displays file status (readonly status, modified status)
  path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
}
local filetype = {
  "filetype",
  colored = true, -- displays filetype icon in color if set to `true`
}
local diff = {
  "diff",
  colored = true, -- displays diff status in color if set to true
  -- all colors are in format #rrggbb
  color_added = nil, -- changes diff's added foreground color
  color_modified = nil, -- changes diff's modified foreground color
  color_removed = nil, -- changes diff's removed foreground color
  symbols = { added = "+", modified = "~", removed = "-" }, -- changes diff symbols
}

local lsp_status_config = require "lv-lualine.lsp_status"
lsp_status_config._init(nil, {
  kind_labels = {},
  current_function = false, -- by treesitter?
  show_filename = true,
  diagnostics = false,
  indicator_separator = " ",
  component_separator = " ",
  indicator_errors = "",
  indicator_warnings = "",
  indicator_info = "🛈",
  indicator_hint = "❗",
  indicator_ok = "",
  spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  status_symbol = " 🇻",
  select_symbol = nil,
  update_interval = 100,
})
local function lsp_statusline()
  if #vim.lsp.buf_get_clients() > 0 then
    return lsp_status_config.status()
  end
end

local gps_statusline = { gps.get_location, cond = gps.is_available }
local ts_statusline = require("nvim-treesitter").statusline

local function get_lsp_clients()
  local msg = "LSP Inactive"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  local lsps = ""
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      -- print(client.name)
      if lsps == "" then
        -- print("first", lsps)
        lsps = client.name
      else
        lsps = lsps .. ", " .. client.name
        break -- Stop at 2 else the statusline explodes
        -- print("more", lsps)
      end
    end
  end
  if lsps == "" then
    return msg
  else
    return lsps
  end
end

local function Qmacro()
  -- TODO: get contents of dot register?
  local Q = vim.fn.getreg "q"
  local dot = vim.fn.getreg "."
  return "Q=<" .. Q .. ">, •='" .. dot:sub(1, 10) .. "'"
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    -- theme = O.theme,
    -- theme = "molokai",
    -- theme = "catppuccino",
    -- theme = "nebulous",
    -- theme = "onedark",
    theme = "material-nvim",
    -- component_separators = { "", "" },
    -- section_separators = { "", "" },
    disabled_filetypes = {},
    globalstatus = true,
  },
  tabline = {},
  sections = {
    lualine_a = { "mode" },
    lualine_b = { filename, gps_statusline },
    lualine_c = { ts_statusline, lsp_statusline },
    lualine_x = { diff, diagnostics },
    lualine_y = { get_lsp_clients, filetype, "branch" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = { filename },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { diff, diagnostics },
  },
  -- tabline = {},
  extensions = {
    "nvim-tree",
    "fugitive",
  },
}
