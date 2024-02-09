" Title:        gomon.nvim
" Description:  A plugin that provides a popup window to display keystrokes.
" Last Change:  4 February 2024
" Maintainer:   Azpect3120 <https://github.com/Azpect3120>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_gomon")
    finish
endif
let g:loaded_gomon = 1

" Exposes the plugin's functions for use as commands in Neovim.
" command! -nargs=0 Keystrokes lua require("keystrokes").toggle()
