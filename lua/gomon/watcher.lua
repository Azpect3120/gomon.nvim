-- Import modules
local display = require("gomon.display")

-- Create a module
local M = {
  _settings = {
    jobs = {
      running = {
        -- id = nil,
        -- command = { "go", "run", "cmd/fbla/main.go" },
      },
    },
    autocmd_id = nil,
  }
}

--- Start the plugin watcher
--- @param bufnr integer: Buffer number
--- @param settings table: Plugin settings
function M.start_watcher (bufnr, settings)
  -- Create auto command to watch for file changes
  M._settings.autocmd_id = vim.api.nvim_create_autocmd("BufWritePost", {
    -- Group name
    group = vim.api.nvim_create_augroup("gomon", { clear = true }),
    -- File pattern to watch
    pattern = settings.pattern,
    -- Description of the auto command
    desc = "GoMon: Watch for file changes",
    -- Execute the callback function when event is triggered
    callback = function()
      -- Stop previous job if running from callers settings
      if settings.jobs.running.id then
        vim.fn.jobstop(settings.jobs.running.id)
      end

      -- Stop previous job if running from local settings
      if M._settings.jobs.running.id then
        vim.fn.jobstop(M._settings.jobs.running.id)
      end

      -- Write to the output buffer
      display.update(bufnr, {
        "File Saved: ".. vim.fn.expand("%"),
        "Executing: " ..table.concat(settings.command, " "),
        "",
      })

      -- Start new job and store the job id in settings
      -- The settings will be updated in this file but 
      -- not updated in the init file until the `stop_watcher`
      -- function is called.
      M._settings.jobs.running.id = vim.fn.jobstart(settings.command, {
        on_stdout = function(_, data)
          if data then
            display.append(bufnr, data)
          end
        end,
        on_stderr = function(_, data)
          if data then
            display.append(bufnr, data)
          end
        end,
      })

      -- Same as above, update the settings with the new command
      M._settings.jobs.running.command = settings.command
    end
  })
end

--- Stop the plugin watcher
--- @param bufnr integer: Buffer number
--- @return table: Updated job settings
function M.stop_watcher (bufnr)
  -- Stop previous job if running
  if M._settings.jobs.running.id then
    vim.fn.jobstop(M._settings.jobs.running.id)
  end

  -- Stop the auto command if exists
  if M._settings.autocmd_id then
    vim.api.nvim_del_autocmd(M._settings.autocmd_id)
  end

  -- Display message
  display.update(bufnr, { "GoMon stopped..." })

  -- Return updated job settings to main file
  return M._settings.jobs
end

-- Return module
return M
