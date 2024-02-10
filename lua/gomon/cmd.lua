local M = {}

--- Listens for a file pattern to be saved
--- @param pattern string
--- @param callback function
function M.Listen(pattern, callback)
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("gomon", { clear = true }),
    desc = "Gomon: Listen for a file pattern to be saved",
    pattern = pattern,
    callback = callback,
  })
end


return M
