# ⏱ Lazy Load - NeoVim

**lazy-load.nvim** is a lazy loader helper for NeoVim, particularly geared for
use with [lazy.nvim](https://github.com/folke/lazy.nvim).

[![Lua](https://img.shields.io/badge/Lua-%23f8f8f8?style=for-the-badge&logo=lua&logoColor=%2302027d)](https://www.lua.org)
[![NeoVim](https://img.shields.io/badge/Neovim%200.7%2B-%234f9946?style=for-the-badge&logo=neovim&logoColor=white&labelColor=%230f191f)](https://neovim.io)

[![Common Changelog](https://common-changelog.org/badge.svg)](https://common-changelog.org)

Main repository lives on [GitLab](https://gitlab.com/xarvex/lazy-load.nvim).
[GitHub](https://github.com/Xarvex/lazy-load.nvim) mostly serves as a mirror,
so it can be read by plugin loaders.


## 🔱 Features

- ⌨️ Allows setting keymaps to lazily load the required module on press,
while retaining normal functionality.

Planned:

- Syncing together [lazy.nvim](https://github.com/folke/lazy.nvim) `cmd` and
`keys` options.
- Support for other plugin managers.

## 🔧 Requirements

- [NeoVim](https://neovim.io) >= **0.7.0** (to use vim.keymap)

[lazy.nvim](https://github.com/folke/lazy.nvim) is recommended for that true
lazy loading experience.

## ⚙️ Configuration

Coming soon in order to configure towards different plugin managers.


## 💡 Usage

It is highly recommended to have a separate location where plugins are loaded,
as it will allow you to require this plugin at the top scope.

This example will be using [lazy.nvim](https://github.com/folke/lazy.nvim),
if you would like to see another module loader you are welcome to contribute.

For a more practical example see my full
[configuration](https://gitlab.com/dotfyls/neovim).


#### Initialization

In `init.lua` or wherever you load
[lazy.nvim](https://github.com/folke/lazy.nvim), change:

```lua
-- this assumes loading from a directory named plugin

require("lazy").setup("plugin")
-- or
require("lazy").setup({{ import = "plugin" }})
```

To:

```lua
-- must load before use in loading other plugins

require("lazy").setup({
    {
        "https://gitlab.com/xarvex/lazy-load.nvim",
        lazy = true -- to only load when require called
    },
    -- or "https://gitlab.com/xarvex/lazy-load.nvim" to not lazily load
    { import = "plugin" }
})
-- or
require("lazy").setup({
    {
        "xarvex/lazy-load.nvim", -- uses GitHub mirror (kept up to date)
        lazy = true
    },
    -- or "xarvex/lazy-load.nvim" to not lazily load
    { import = "plugin" }
})
```


#### Calling

Well shown when using [harpoon](https://github.com/ThePrimeagen/harpoon),
where you are loading other plugins:

```lua
local lazy_load = require("lazy-load")
-- <...>
{
    "ThePrimeagen/harpoon",
    lazy = true,
    
    -- tables returned are in the format { <keymap>, <command> } for use with lazy.nvim
    keys = {
        -- both of these ways can be used to call
        lazy_load.keymap_require("n", "<leader>a", "harpoon.mark", "add_file"),
        lazy_load.keymap_require("n", "<leader>h", "harpoon.ui", function(ui) ui.toggle_quick_menu() end),

        -- different ways to pass variables
        lazy_load.keymap_require("n", "<leader>1", "harpoon.ui", "nav_file", 1),
        lazy_load.keymap_require("n", "<leader>2", "harpoon.ui", function(ui) ui.nav_file(2) end),
        lazy_load.keymap_require("n", "<leader>3", "harpoon.ui", function(ui, num) ui.nav_file(num) end, 3),
    }
}
```


### 📃 License

_This project is licensed under **Mozilla Public License 2.0**._
