-- Import modules
local display = require("gomon.display")
local Path = require("plenary.path")

-- Create module
local M = {}

--- Parse the pattern from the input configuration file.
--- @param line string: The line to parse the pattern from
--- @return table: The parsed pattern
local function parse_pattern (line)
  local regex = "Pattern:%s+(.*)"
  local pattern = {}
  local extractedPattern = string.match(line, regex)
  if extractedPattern then
    for p in string.gmatch(extractedPattern, "%S+") do
      table.insert(pattern, p)
    end
  end
  return pattern
end

--- Parse the command from the input configuration file.
--- @param line string: The line to parse the command from
--- @return table: The parsed command
local function parse_command (line)
  local regex = "Command:%s(.*)"
  local pattern = {}
  local extractedPattern = string.match(line, regex)
  if extractedPattern then
    for p in string.gmatch(extractedPattern, "%S+") do
      table.insert(pattern, p)
    end
  end
  return pattern
end

--- Update the system configuration with the new settings.
--- @param cwd string: The current working directory
--- @param lines table: The lines to update the system configuration with
local function update_sys_config (cwd, lines)
  -- Use the api function to get the entire system configuration
  local config = M.get_full_config()

  -- Update the configuration with the new settings
  if config[cwd] then
    config[cwd].pattern = parse_pattern(lines[1])
    config[cwd].command = parse_command(lines[2])
  else
    config[cwd] = {
      pattern = parse_pattern(lines[1]),
      command = parse_command(lines[2]),
    }
  end

  -- Write the new configuration to the data file
  Path:new(Path:new(string.format("%s/gomon.json", vim.fn.stdpath("data")))):write(vim.json.encode(config), "w")
end

--- Enables the configuration buffer to be written to.
--- Creates an autocmd to listen for the BufWritePost event.
--- When the file is saved, it will be saved in the root directory of 
--- the project with the name ".gomon_output.txt".
--- @param bufnr number: The buffer number to enable writing to
--- @param winnr number: The window number to hide when saved
local function enable_config(bufnr, winnr)
  M.auid = vim.api.nvim_create_autocmd("BufWritePost", {
    -- Group name
    group = vim.api.nvim_create_augroup("gomon_config", { clear = true}),
    -- Define the function to only listen for the configuration 
    -- buffer BufWritePost event.
    pattern = "<buffer=" .. bufnr .. ">",
    -- Description of the auto command
    desc = "GoMon: Watch for configuration changes",
    -- Execute the function to update the configuration 
    callback = function()
      -- Get the lines from the buffer
      -- Only returns the lines that are required for the configuration
      -- e.g: 
      --  Pattern: *.go ...
      --  Command: go run ./cmd/fbla/main.go
      local lines = vim.api.nvim_buf_get_lines(bufnr, 2, 4, false)

      -- Get the current working directory
      local cwd = vim.fn.getcwd() or "~"

      -- Update system configuration with the new settings
      update_sys_config(cwd, lines)

      -- Disable writing to the buffer
      vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })

      -- Hide window and clear buffer
      display.update(bufnr, { "Configuration saved!" })
      vim.api.nvim_win_close(winnr, true)

      -- Delete the file saved from the writing
      -- If an error occurs, print the error message.
      local code, message = vim.api.nvim_call_function("delete", { cwd .. "/.gomon_output.txt" })
      if code ~= 0 then
        print("Error: " .. message)
      end

      -- Delete the auto command
      vim.api.nvim_del_autocmd(M.auid)
    end
  })
end

--- Open the configuration file for the plugin.
--- @param bufnr number: The buffer number to open the configuration file in
--- @param winnr number: The window number to open the configuration file in
--- @param settings table: The settings to display in the configuration file
function M.open_config(bufnr, winnr, settings)
  -- Update the display on the buffer
  display.update(bufnr, {
    "GoMon Configuration:",
    "---------------------",
    "Pattern: " .. table.concat(settings.pattern, ", "),
    "Command: " .. table.concat(settings.command, " "),
  })

  -- Update buffer settings
  vim.api.nvim_set_option_value("buftype", "", { buf = bufnr })

  -- Enable file save auto command
  enable_config(bufnr, winnr)

  -- Switch to the configuration window
  vim.api.nvim_set_current_win(winnr)
end

--- Get the full configuration for the system.
--- @return table: The full configuration for the system
function M.get_full_config()
  -- Create path to data file
  local data_path = Path:new(string.format("%s/gomon.json", vim.fn.stdpath("data")))

  -- If the file does not exist, create it with blank data
  if not data_path:exists() then
    data_path:write(vim.json.encode({}), "w")
  end

  -- Read the data from the file
  local out_data = data_path:read()

  -- Again, ensure file exists and if not 
  -- create it with blank data and re-read
  if not out_data or out_data == "" then
    data_path:write(vim.json.encode({}), "w")
    out_data = data_path:read()
  end

  -- Decode data from JSON to create a Lua table 
  -- which contains the previous system configuration
  return vim.json.decode(out_data)
end

--- Get the configuration for the current working directory.
--- @return table: The configuration for the current working directory
function M.get_cwd_config()
  -- Get the current working directory
  local cwd = vim.fn.getcwd() or "~"

  -- Get the full system configuration
  local config = M.get_full_config()

  -- Return the configuration for the current working directory
  return config[cwd]
end

--- Reset the configuration for the current working directory.
function M.clear_cwd_config()
  -- Get the current working directory
  local cwd = vim.fn.getcwd() or "~"

  -- Get the full system configuration
  local config = M.get_full_config()

  -- Update the configuration with the new settings
  if config[cwd] then
    config[cwd] = nil
  end

  -- Write the new configuration to the data file
  Path:new(Path:new(string.format("%s/gomon.json", vim.fn.stdpath("data")))):write(vim.json.encode(config), "w")
end

--- Reset the configuration for the entire system.
function M.reset_config()
  -- Write the new configuration to the data file
  Path:new(Path:new(string.format("%s/gomon.json", vim.fn.stdpath("data")))):write(vim.json.encode({}), "w")
end

-- Export module
return M
