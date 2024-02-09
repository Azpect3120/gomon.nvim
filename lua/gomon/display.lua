-- Create module
local M = {}

--- Creates a buffer 
--- @return integer: Buffer number
function M.CreateBuffer ()
  return vim.api.nvim_create_buf(false, true)
end


--- Creates a floating window for a buffer
--- @param buffnr integer: Buffer number
--- @return integer: Window number
function M.CreateFloat (buffnr)
  local py, px = 2, 4
  local width = vim.api.nvim_get_option("columns") - (px * 2)
  local height = vim.api.nvim_get_option("lines") - (py * 2)

  return vim.api.nvim_open_win(buffnr, true, {
    relative = "editor",
    style = "minimal",
    border = "rounded",
    col = px,
    row = py,
    width = width,
    height = height,
    title = "Result:",
    title_pos = "center",
  })
end

-- Export module
return M
