-- Imports
local watcher = require("gomon.watcher")
local display = require("gomon.display")

-- Module object
local M = {}

--- Setup the plugin
--- @param config table: Plugin configuration
function M.setup (config)
  -- Handle case where config is nil or an empty table
  config = config or {}

  -- Setup the plugin config
  M.config = {
    -- Output window configuration
    window = {
      -- Style of the output window
      -- e.g. float, split_right, split_left, split_bottom, split_top
      style = config.window and config.window.style or "float",

      -- Size of the output window. Only used for float style
      -- e.g. small, medium, large
      size = config.window and config.window.size or "medium",

      -- Title of the output window
      title = config.window and config.window.title or " GoMon Output... ",

      -- Border style of the output window. Only used for float style
      -- e.g. single, double, rounded, shadow, or an array of chars
      border = config.window and config.window.border or "rounded",

      -- Wrap text in the output window
      wrap = config.window and config.window.wrap or false,
    },
    -- Open the output window on start
    display_on_start = config.display_on_start or true,

    -- Close the output window on stop
    close_on_stop = config.close_on_stop or true,
  }

  -- Setup plugin default settings
  M._settings = {
    pattern = { "*.go" },
    command = { "go", "run", "./cmd/fbla/main.go" },
    jobs = {
      running = {
        -- id = nil,
        -- command = { "go", "run", "cmd/fbla/main.go" },
      },
    },
    started = false,
    output = false,
  }

  -- Create buffer for output
  M._settings.bufnr = display.create_buffer()
end


-- Start the plugin's watcher.
-- Uses the most recent settings to start the watcher.
function M.start()
  -- Ensure plugin has not been started
  if M._settings.started then
    return
  end

  -- Start the watcher
  watcher.start_watcher(M._settings.bufnr, M._settings)

  -- Display the output window
  if M.config.display_on_start then
    if M.config.window.style == "float" then
      M._settings.winnr = display.create_float(M._settings.bufnr, M.config.window)
    else
      M._settings.winnr = display.create_split(M._settings.bufnr, M.config.window)
    end
  end

  -- Display startup message
  display.update(M._settings.bufnr, { "GoMon started..." })

  -- Update started and output setting
  M._settings.started = true
  M._settings.output = true
end

-- Stop the plugin's watcher.
-- The most recent job id and command is stored in the settings
-- and is updated here when the stop command is executed.
function M.stop()
  -- Ensure plugin has been started
  if not M._settings.started then
    return
  end

  -- Stop the watcher
  M._settings.jobs = watcher.stop_watcher(M._settings.bufnr)

  -- Hide the output window
  if M.config.close_on_stop then
    display.hide_window(M._settings.winnr)
  end

  -- Update started and output setting
  M._settings.started = false
  M._settings.output = false
end

-- Restart the plugin's watcher.
function M.restart()
  -- Stop the watcher
  M._settings.jobs = watcher.stop_watcher(M._settings.bufnr)

  -- Start the watcher
  watcher.start_watcher(M._settings.bufnr, M._settings)

  -- Display startup message
  display.append(M._settings.bufnr, { "GoMon started..." })
end

-- Toggles the plugin's watcher.
function M.toggle()
  -- Start or stop the watcher and update the settings
  if M._settings.started then
    M._settings.started = false
    M.stop()
  else
    M._settings.started = true
    M.start()
  end
end

-- Hides the plugin's output window.
-- Continues to run the watcher in the background.
function M.hide()
  -- Hide output window and update settings if currently displayed and is running
  if M._settings.output and M._settings.started then
    display.hide_window(M._settings.winnr)
    M._settings.output = false
  end
end

-- Shows the plugin's output window.
-- Writes the result from the background watcher to the output window.
function M.show()
  -- Show output window and update settings if currently hidden and is running
  if not M._settings.output and M._settings.started then
    -- Show the output window
    if M.config.display_on_start then
      if M.config.window.style == "float" then
        M._settings.winnr = display.create_float(M._settings.bufnr, M.config.window)
      else
        M._settings.winnr = display.create_split(M._settings.bufnr, M.config.window)
      end
    end
    -- Update settings
    M._settings.output = true
  end
end

-- Toggles the plugin's output window.
-- Continues to run the watcher in the background.
function M.toggle_display()
  -- Toggle the output window and update the settings
  if M._settings.output then
    M.hide()
  else
    M.show()
  end
end

-- Finally, return the module
return M
