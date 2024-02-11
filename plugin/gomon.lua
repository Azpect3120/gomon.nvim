-- Title:        gomon.nvim
-- Description:  A plugin that allows hot reload for your Go applications.
-- Last Change:  10 February 2024
-- Maintainer:   Azpect3120 <https://github.com/Azpect3120>

-- Prevents the plugin from being loaded multiple times. If the loaded
-- variable exists, do nothing more. Otherwise, assign the loaded
-- variable and continue running this instance of the plugin.
if not _G.myPluginLoaded then
  -- Exposes the plugin's functions for use as commands in Neovim.
  vim.api.nvim_create_user_command(
    "Gomon",
    function (opts)
      local arg = opts.fargs[1]
      if arg == "start" then
        require("gomon").start()
      elseif arg == "stop" then
        require("gomon").stop()
      elseif arg == "restart" then
        require("gomon").restart()
      elseif arg == "toggle" then
        require("gomon").toggle()
      elseif arg == "hide" then
        require("gomon").hide()
      elseif arg == "show" then
        require("gomon").show()
      elseif arg == "toggle_display" then
        require("gomon").toggle_display()
      elseif arg == "config" then
        require("gomon").update_config()
      elseif arg == "clear_config" then
        require("gomon").clear_config()
      elseif arg == "reset" then
        require("gomon").reset()
     end
    end,
    {
      nargs = 1,
      complete = function (_, _, _)
        return { "start", "stop", "restart", "toggle", "hide", "show", "toggle_display", "config", "clear_config", "reset" }
      end
    }
  )

  -- Ensure plugin is only loaded once
  _G.myPluginLoaded = true
end
