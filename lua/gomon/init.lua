-- Imports
local utils = require('gomon.utils')
local display = require('gomon.display')

-- Module object
local M = {}

function M.toggle ()
  local bufnr = display.CreateBuffer()
  local winnr = display.CreateFloat(bufnr)
end


-- Finally, return the module
return M
