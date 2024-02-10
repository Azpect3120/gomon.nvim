" Title:        gomon.nvim
" Description:  A plugin that allows hot reload for your Go applications.
" Last Change:  8 February 2024
" Maintainer:   Azpect3120 <https://github.com/Azpect3120>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_gomon")
    finish
endif
let g:loaded_gomon = 1

" Exposes the plugin's functions for use as commands in Neovim.
command! -nargs=0 GomonStart lua require("gomon").start()
command! -nargs=0 GomonStop lua require("gomon").stop()
command! -nargs=0 GomonRestart lua require("gomon").restart()
command! -nargs=0 GomonToggle lua require("gomon").toggle()
command! -nargs=0 GomonHide lua require("gomon").hide()
command! -nargs=0 GomonShow lua require("gomon").show()
command! -nargs=0 GomonToggleDisplay lua require("gomon").toggle_display()
command! -nargs=0 GomonConfig lua require("gomon")
