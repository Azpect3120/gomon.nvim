-- Create module
local M = {}

--- Creates a buffer 
--- @return integer: Buffer number
function M.create_buffer ()
  -- Create buffer
  local bufnr = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_buf_set_name(bufnr, ".gomon_output.txt")
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = bufnr })
  vim.api.nvim_set_option_value("swapfile", false, { buf = bufnr })
  vim.api.nvim_set_option_value("buflisted", false, { buf = bufnr })

  -- Return buffer number
  return bufnr
end

--- Creates a floating window for a buffer
--- @param bufnr integer: Buffer number
--- @param config table: Window configuration
--- @return integer: Window number
function M.create_float (bufnr, config)
  -- Determine window size
  local py, px = 6, 32
  if config.size == "small" then
    py, px = 10, 48
  elseif config.size == "medium" then
    py, px = 6, 24
  elseif config.size == "large" then
    py, px = 3, 8
  end

  -- Create window & return window number
  local winnr = vim.api.nvim_open_win(bufnr, false, {
    relative = "editor",
    style = "minimal",
    border = config.border,
    col = px,
    row = py,
    width = vim.api.nvim_get_option_value("columns", {}) - (px * 2),
    height = vim.api.nvim_get_option_value("lines", {}) - (py * 2),
    title = config.title,
    title_pos = "center",
  })

  -- Set wrap options
  vim.api.nvim_set_option_value("wrap", config.wrap, { win = winnr })

  -- Return window number
  return winnr
end

--- Creates a split window for a buffer
--- @param bufnr integer: Buffer number
--- @param config table: Window configuration
function M.create_split (bufnr, config)
  -- Get the current window number
  local start_win = vim.api.nvim_get_current_win()

  -- Create split window
  if config.style == "split_right" then
    vim.api.nvim_command("botright vnew")
  elseif config.style == "split_left" then
    vim.api.nvim_command("leftabove vnew")
  elseif config.style == "split_bottom" then
    vim.api.nvim_command("botright new")
  elseif config.style == "split_top" then
    vim.api.nvim_command("aboveleft new")
  end

  -- Get window number of new window
  local new_winnr = vim.api.nvim_get_current_win()

  -- Set buffer to new window
  vim.api.nvim_win_set_buf(new_winnr, bufnr)

  -- Set wrap options
  vim.api.nvim_set_option_value("wrap", config.wrap, { win = new_winnr })

  -- Set active window back to start window
  vim.api.nvim_set_current_win(start_win)

  -- Return new window number
  return new_winnr
end

--- Hides a window
--- @param winnr integer: Window number
function M.hide_window (winnr)
  vim.api.nvim_win_hide(winnr)
end

--- Updates a buffer with new lines
--- @param bufnr integer: Buffer number
--- @param lines table: Lines to update the buffer with
function M.update(bufnr, lines)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end
---
--- Appends lines to a buffer
--- @param bufnr integer: Buffer number
--- @param lines table: Lines to append to buffer
function M.append(bufnr, lines)
  vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
end

-- Export module
return M
