<div align="center">

# Gomon.nvim
##### Hot reloading for your GoLang applciations built right into your editor.

[![Lua](https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua)](http://www.lua.org)
[![Neovim](https://img.shields.io/badge/Neovim%200.8+-purple.svg?style=for-the-badge&logo=neovim)](https://neovim.io)

<img alt="Golang Logo" height="120" src="./assets/golang.svg.png" style="margin: 40px;" />
</div>

## ⟳ Table of Contents
- [The Problem](#-The-Problem)
- [The Solution](#-The-Solution)
    - [Inspiration](#Inspiration)
- [Installation](#-Installation)
- [Getting Started](#-Getting-Started)
- [Usage](#-Usage)
- [API](#-API)
    - [Configuration](#Configuration)
- [Change Log](#-Change-Log)
- [Contribution](#-Contribution)
- [License](#-License)

## ⟳ The Problem
Have you ever experienced the need to constantly restart and rerun a large Golang project? Are you not interested in using 
Docker? Does the repetitive setup of Air drain your sanity? Are you tired of launching a terminal and slowing down your 
workflow just to copy and paste the same command repeatedly?

## ⟳ The Solution
Introducing my groundbreaking Neovim plugin, a game-changer for Golang developers! Tired of the tedious and time-consuming 
process of manually restarting and reloading your applications? Frustrated by the constant interruptions to your workflow? Say 
goodbye to these challenges! With this plugin, I've revolutionized the way Golang applications are developed. Experience the 
sheer joy and excitement of seamless live reloading, as your code changes come to life instantly, without missing a beat. 
Embrace a new era of productivity and creativity, where you can focus on what truly matters – crafting exceptional Golang
applications – while my plugin takes care of the rest. It's time to elevate your development experience and unlock your full 
potential!

### Inspiration
- This project was inspired by the NodeJS package [Nodemon](https://www.npmjs.com/package/nodemon)
- The name Gomon was inspired by [n8hadden](https://github.com/n8hadden)

## ⟳ Installation
- Neovim 0.8.0+ required
- Install using your preferred package manager
- Depends on [plenary.nvim](https://github.com/nvim-lua/plenary.nvim), if you have it installed already else you may leave it out of this install

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use  {
    'azpect3120/gomon.nvim',
    requires = {
        { 'nvim-lua/plenary.nvim' }
    }
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
-- init.lua:
    {
        'azpect3120/gomon.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    }

-- plugins/gomon.lua:
    return {
        'azpect3120/gomon.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' }
    }

```

Using [vim-plug](https://github.com/junegunn/vim-plug)
```lua
Plug 'nvim-lua/plenary.nvim'
Plug 'azpect3120/gomon.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)
```lua
call dein#add('nvim-lua/plenary.nvim')
call dein#add('azpect3120/gomon.nvim')
```


## ⟳ Getting Started

### Quick Notes
There are no default keybindings created by this plugin. You may create your own to meet your 
own needs, but none will be created for you!

You **MUST** run `gomon.setup()` in order for this plugin to function properly. Without it, config 
changes will fail and nothing will work!

### Basic Setup
Here is my basic setup using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "azpect3120/gomon.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function ()
    -- REQUIRED
    require("gomon").setup({
      window = {
        style = "split_right",
        wrap = false,
      },
      display_on_start = true,
      close_on_stop = false,
    })
  end
}
```

## ⟳ Usage
All of the API functions are exported to user commands which can be run like any normal command, e.g. `Gomon start`

#### Reload Commands
- `:Gomon start` will start the live reloader and use the default configuration if a config has not been specified
- `:Gomon stop` will stop the live reloader
- `:Gomon toggle` will toggle the live reloader
- `:Gomon restart` will restart the live reloader, required after the config has been changed

#### Output Commands
- `:Gomon hide` will hide the output window but continue running the reloader
- `:Gomon show` will display the output window and write the output from the reloader into the buffer
- `:Gomon toggle_display` will toggle the output window

#### Config Commands
- `:Gomon config` will toggle the config menu. The config menu can be used to update the pattern and command ran by the watcher.
Any changes to this buffer will be saved to the system when the file is written, which enables persistent storage between sessions.
The only lines that should be touched in the config will are the `Pattern: ...` and `Command: ...` lines, anything else will be ignored. 
Once you are happy with the changes made in the config window, write the file with `:w` and it will be saved to the system. The 
watcher will require a restart with `:Gomon restart` or to be started for the first time with `:Gomon start` to enable the new changes!
- `:Gomon clear_config` will clear the config for the current working directory from the system data file. The changes will not be in 
effect until the watcher is restarted with `:Gomon restart` or started for the first time with `:Gomon start`
- `:Gomon reset` will reset the entire system config back to the default config. The changes will not be in effect until the watcher 
is restarted with `:Gomon restart` or started for the first time with `:Gomon start`

**Default Configuration:**
```txt
GoMon Configuration:
---------------------
Pattern: *.go
Command: go run ./main.go
```
- `Pattern` should contain a list of file name patterns split with spaces (not commas)
- `Command` should contain the command run by the watcher when a change is detected

**Example Configuration:**
```txt
GoMon Configuration:
---------------------
Pattern: *.go *.tmpl
Command: go run ./cmd/go-app/main.go
```




## ⟳ API
You can create custom behavior of the plugin using all of the function exported 
by the plugin.

The plugin comes with complete functionality out of the box so this step is not
required but for some intense users, it may be nice to use these functions to 
incorporate the plugins functionality into their workflow.

```lua
local gomon = require("gomon")

-- REQUIRED:
-- You may provide your own configuration here
gomon.setup({})

-- Start the plugin's reload watcher
gomon.start()

-- Stops the plugin's reload watcher
gomon.stop()

-- Restarts the plugin's reload watcher
gomon.restart()

-- Toggles the plugin's reload watcher
-- If started it will stop it, if not, it will start it
gomon.toggle()

-- Hides the plugin's output window
-- Watcher will continue to run in the background
gomon.hide()

-- Displays the plugin's output window
-- Watchers output will be added to the new display
gomon.show()

-- Toggles the plugin's output window
-- If displaying it will hide it, if not, it will display it
gomon.toggle_display()

-- Opens the plugin's config window
-- The config will replace the output window until it is saved
-- If the window is hidden, it will toggle the display
-- Once this buffer is saved, the watcher output will resume
-- Watcher does run in the background while this window is open
-- Watcher will need to be restarted to run with updated config
gomon.update_config()

-- Clears the config for the current working directory
-- Changes will not in affect until the watcher is restarted
gomon.clear_config()

-- Resets the entire system config back to the default config
-- Changes will not in affect until the watcher is restarted
gomon.reset()
```

### Configuration
The window used to display the output as well as some basic functionality can be 
configured to meet your tastes and specific needs.

**Default Configuration:**

```lua
return {
  "azpect3120/gomon.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function ()
    require("gomon").setup({
        window = {
          -- Style of the output window
          -- e.g. float, split_right, split_left, split_bottom, split_top
          style = "float",
          -- Size of the output window. Only used for float style
          -- e.g. small, medium, large
          size = "medium",
          -- Title of the output window
          title = " GoMon Output... ",
          -- Border style of the output window. Only used for float style
          -- e.g. single, double, rounded, shadow, or an array of chars
          border = "rounded",
          -- Wrap text in the output window
          wrap = false,
        },
        -- Open the output window on start
        display_on_start = true,
        -- Close the output window on stop
        close_on_stop = true,
      })
    end
}
```

## ⟳ Change Log
All notable changes to this project will be documented in this section.

### [1.0.1] - 2024-10-12

- Updated the config parser to not display commas when viewing the config.
- This was causing issues when changing the config and saving it, the 
  commas would be saved to the file and cause issues when the file was read back in.

## ⟳ Contribution
Contributions are welcome! If you'd like to contribute to this project, please follow these steps:

1. Fork the project.
1. Create a new branch for your feature or bug fix.
1. Make your changes.
420. Test your changes thoroughly.
69. Create a pull request.

## ⟳ License
This project is licensed under azpect3120 the **MIT License**

View [LICENSE](https://github.com/azpect3120/gomon.nvim/blob/master/LICENSE)
