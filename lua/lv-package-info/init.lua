local M = {}
M.setup = function()
  utils.define_augroups {
    _package_info_nvim_load = {
      { "BufRead", "package.json", [[lua require"lv-package-info".ftplugin()]] },
    },
  }
  -- require"package-info".setup()
end
M.ftplugin = function()
  local packinfo = utils.cmd.require "package-info"
  mappings.localleader {
    s = packinfo.show,
    d = packinfo.delete,
    c = packinfo.change_version,
    i = packinfo.install,
    R = packinfo.reinstall,
  }
end
return M
