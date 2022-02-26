-- if not package.loaded['galaxyline'] then
--   return
-- end
local gl = require "galaxyline"
-- get my theme in galaxyline repo
-- local colors = require('galaxyline.theme').default
local colors = {
  -- bg = '#2E2E2E',
  bg = "#292D38",
  yellow = "#DCDCAA",
  dark_yellow = "#D7BA7D",
  cyan = "#4EC9B0",
  green = "#608B4E",
  light_green = "#B5CEA8",
  string_orange = "#CE9178",
  orange = "#FF8800",
  purple = "#C586C0",
  magenta = "#D16D9E",
  grey = "#858585",
  blue = "#569CD6",
  vivid_blue = "#4FC1FF",
  light_blue = "#9CDCFE",
  red = "#D16969",
  error_red = "#F44747",
  info_yellow = "#FFCC66",
}

local condition = require "galaxyline.condition"
local gls = gl.section
gl.short_line_list = { "NvimTree", "vista", "dbui", "packer", "minimap", "spectre_panel" }

local mode_indicator = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.blue,
        i = colors.green,
        v = colors.purple,
        [""] = colors.purple,
        V = colors.purple,
        c = colors.magenta,
        no = colors.blue,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.red,
        Rv = colors.red,
        cv = colors.blue,
        ce = colors.blue,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.blue,
        t = colors.blue,

        -- libmodal modes
      }
      local mode_name = vim.fn.mode()
      local mode_text = "▊"
      if vim.g.libmodalActiveModeName then
        -- mode_name = vim.g.libmodalActiveModeName
        -- mode_text = mode_name
      end

      vim.cmd("hi GalaxyViMode guifg=" .. mode_color[mode_name])
      return "▊"
    end,
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
    -- highlight = {colors.red, colors.bg}
  },
}
local ins = table.insert
ins(gls.left, mode_indicator)
-- print(vim.fn.getbufvar(0, 'ts'))
-- vim.fn.getbufvar(0, "ts") -- vim.b.ts

ins(gls.left, {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineGit",
  },
})

ins(gls.left, {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

ins(gls.left, {
  DiffAdd = {
    provider = "DiffAdd",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = "StatusLineGitAdd",
  },
})

ins(gls.left, {
  DiffModified = {
    provider = "DiffModified",
    condition = condition.hide_in_width,
    icon = " 柳",
    highlight = "StatusLineGitChange",
  },
})

ins(gls.left, {
  DiffRemove = {
    provider = "DiffRemove",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = "StatusLineGitDelete",
  },
})
ins(gls.left, {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.hide_in_width,
    icon = "",
    highlight = "StatusLineNC",
    -- highlight = { colors.purple, colors.bg },
  },
})
ins(gls.left, {
  FileName = {
    -- provider = 'FileName',
    provider = function(modified_icon, readonly_icon)
      local file = vim.fn.expand "%:p"
      if vim.fn.empty(file) == 1 then
        return ""
      end
      --   if string.len(file_readonly(readonly_icon)) ~= 0 then
      --     return file .. file_readonly(readonly_icon)
      --   end
      local icon = modified_icon or ""
      if vim.bo.modifiable then
        if vim.bo.modified then
          return file .. " " .. icon .. "  "
        end
      end
      return file .. " "
    end,
    condition = condition.hide_in_width,
    icon = "",
    highlight = "StatusLineNC",
    -- highlight = { colors.purple, colors.bg },
  },
})
--[[ ins(gls.left, {
  VistaPlugin = {
    provider = "VistaPlugin",
    condition = condition.hide_in_width,
    icon = "",
    highlight = { colors.cyan, colors.bg },
  },
}) ]]

ins(gls.left, {
  Filler = {
    provider = function()
      return " "
    end,
    highlight = "StatusLineGitDelete",
  },
})
-- get output from shell command
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = s:gsub("^%s+", "")
  s = s:gsub("%s+$", "")
  s = s:gsub("[\n\r]+", " ")
  return s
end
-- cleanup virtual env
local function env_cleanup(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch "([^/]+)" do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end
local function PythonEnv()
  if vim.bo.filetype == "python" then
    local venv = os.getenv "CONDA_DEFAULT_ENV"
    if venv ~= nil then
      return "🅒 (" .. env_cleanup(venv) .. ")"
    end
    venv = os.getenv "VIRTUAL_ENV"
    if venv ~= nil then
      return "  (" .. env_cleanup(venv) .. ")"
    end
    return ""
  end
  return ""
end
ins(gls.left, {
  VirtualEnv = {
    provider = PythonEnv,
    highlight = "StatusLineTreeSitter",
    event = "BufEnter",
  },
})

ins(gls.right, {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = "StatusLineLspDiagnosticsError",
  },
})
ins(gls.right, {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",

    highlight = "StatusLineLspDiagnosticsWarning",
  },
})

ins(gls.right, {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = "  ",

    highlight = "StatusLineLspDiagnosticsInformation",
  },
})

ins(gls.right, {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = "  ",

    highlight = "StatusLineLspDiagnosticsHint",
  },
})

ins(gls.right, {
  TreesitterIcon = {
    provider = function()
      if next(vim.treesitter.highlighter.active) ~= nil then
        return "  "
      end
      return ""
    end,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineTreeSitter",
  },
})

local function get_lsp_client(msg)
  msg = msg or "LSP Inactive"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  local lsps = ""
  for i, client in ipairs(clients) do
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

ins(gls.right, {
  ShowLspClient = {
    provider = get_lsp_client,
    condition = function()
      local tbl = { ["dashboard"] = true, [" "] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    icon = "  ",
    highlight = "StatusLineNC",
  },
})

ins(gls.right, {
  LineInfo = {
    provider = "LineColumn",
    separator = "  ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

-- ins(gls.right, {
--   PerCent = {
--     provider = "LinePercent",
--     separator = " ",
--     separator_highlight = "StatusLineSeparator",
--     highlight = "StatusLineNC",
--   },
-- })

ins(gls.right, {
  Tabstop = {
    provider = function()
      return "SW:" .. vim.api.nvim_buf_get_option(0, "shiftwidth") .. " "
    end,
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

ins(gls.right, {
  BufferType = {
    provider = "FileTypeName",
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

-- ins(gls.right, {
--   FileEncode = {
--     provider = "FileEncode",
--     condition = condition.hide_in_width,
--     separator = " ",
--     separator_highlight = "StatusLineSeparator",
--     highlight = "StatusLineNC",
--   },
-- })

ins(gls.right, {
  Space = {
    provider = function()
      return " "
    end,
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

ins(gls.right, mode_indicator)

ins(gls.short_line_left, {
  BufferType = {
    provider = "FileTypeName",
    separator = " ",
    separator_highlight = "StatusLineSeparator",
    highlight = "StatusLineNC",
  },
})

ins(gls.short_line_left, {
  SFileName = {
    provider = "SFileName",
    condition = condition.buffer_not_empty,

    highlight = "StatusLineNC",
  },
})

-- ins(gls.short_line_right[1] = {BufferIcon = {provider = 'BufferIcon', highlight = {colors.grey, colors.bg}}})
