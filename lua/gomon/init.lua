-- Imports
local utils = require('gomon.utils')
local display = require('gomon.display')

-- Module object
local M = {
  bufnr = display.CreateBuffer(),
  winnr = 0,
}

function M.action (action)
  if action == "toggle" then
    M.winnr = display.CreateFloat(M.bufnr)

  elseif action == "start" then
    M.winnr = display.CreateFloat(M.bufnr)

  elseif action == "stop" then
    vim.api.nvim_win_close(M.winnr, true)
  end
end


-- Finally, return the module
return M
