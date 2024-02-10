# From TJ

```lua
local output_bufnr, command = 34, { "go", "run", "main.go" }

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("teej-automagic", { clear = true }),
    pattern = "*.go",
    callback = function()
        local append_data = function(_, data)
            if data then
                vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
            end
        end
        local filename = vim.fn.expand("%")
        vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "Saved file: " .. filename })
        vim.fn.jobstart(command, {
            stdout_buffered = true,
            on_stdout = append_data,
            on_stderr = append_data,
        })
    end
})
```


# Old Example Working Code
```lua
function M.test()
  M.bufnr = display.create_buffer()
  M.winnr = display.create_float(M.bufnr, "medium", "rounded", " GoMon Result... ")
  -- M.winnr = display.create_split(M.bufnr)

  cmd.Listen("*.go", function ()
    -- Stop the running job
    vim.fn.jobstop(M.running_job_nr)

    local filename = vim.fn.expand("%")
    local command = { "go", "run" , "./cmd/fbla/main.go" }
    display.update(M.bufnr, { filename .. " was saved...", "Running: " .. table.concat(command, " ") })
    -- Update new running job
    M.running_job_nr = vim.fn.jobstart(command, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          display.append(M.bufnr, data)
        end
      end,
      on_stderr = function(_, data)
        if data then
          display.append(M.bufnr, data)
        end
      end,
    })

  end)
end

function M.test_hide()
  display.hide_window(M.winnr)
end
```

# Commands: 

## GomonStart
- Start the autocmd / watcher
- Will also default to opening a window (can be disabled in config)

## GomonStop
- Stop the autocmd / watcher
- Will also default to close the window (maybe disable-able in config?)

## GomonRestart
- Restart the autocmd / watcher
- Will not affect the window
- Basically the same as saving a file LOL

## GomonToggle
- Toggles the watcher on and off
- Basically combines the functionality of `GomonStart` and `GomonStop`

## GomonHide
- Hide the output window
- Does not kill the buffer, therefore it still writes even when hidden

## GomonShow
- Show the output window
- Basically just creates a window using the buffer
- I haven't decided how I want to handle a `GomonShow` command before running `GomonStart`

## GomonToggleDisplay
- Toggles the output window
- Basically combines the functionality of `GomonHide` and `GomonShow`

## GomonConfig
- Opens a window that will allow the user to alter config settings
    - Settings include:
        - pattern
        - path to main.go
        - etc
- Window will be opened with the config written in and allow user to change it
- Config will be saved and loaded from a file stored somewhere on the file system
