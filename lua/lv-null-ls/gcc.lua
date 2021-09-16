local null = require "null-ls"
local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local gcc_diagnostics = {
  method = null.methods.DIAGNOSTICS,
  filetypes = { "c", "cpp" },
  name = "gcc-diagnostics",
  async = true,
  generator_opts = {
    -- `ninja ../file^`
    command = "cmake",
    args = { -- TODO: gather arguments from compile_commands.json
      "--build",
      "build",
    },
    to_stdin = false,
    from_stderr = true,
    format = "line",
    on_output = h.diagnostics.from_pattern(
      [[(%w+):(%d+):(%d+): (%w+): (.*)]],
      { "file", "row", "col", "severity", "message" },
      {
        severities = {
          ["fatal error"] = h.diagnostics.severities.error,
          ["error"] = h.diagnostics.severities.error,
          ["note"] = h.diagnostics.severities.information,
          ["warning"] = h.diagnostics.severities.warning,
        },
      }
    ),
  },
}

return setmetatable(gcc_diagnostics, {
  __index = function(tbl, key)
    if key == "with" then
      return function(arg)
        return vim.tbl_deep_extend("keep", arg, gcc_diagnostics)
      end
    else
      return nil
    end
  end,
})
