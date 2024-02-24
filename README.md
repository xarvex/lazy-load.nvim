# ⏱ Lazy Load - Neovim

**lazy-load.nvim** is a lazy loader helper for [Neovim], particularly geared
for use with [lazy.nvim].

[![Neovim](https://img.shields.io/badge/Neovim%200.7%2B-%234f9946?style=for-the-badge&logo=neovim&logoColor=white&labelColor=%230f191f)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-%23f8f8f8?style=for-the-badge&logo=lua&logoColor=%2302027d)](https://www.lua.org)

[![Common Changelog](https://common-changelog.org/badge.svg)](https://common-changelog.org)

Main repository lives on [GitLab](https://gitlab.com/xarvex/lazy-load.nvim).
Mirror can be found through [GitHub](https://github.com/Xarvex/lazy-load.nvim),
as well so it can be read by plugin loaders.


## 🔱 Features

- ⚡️ Incremental and deferred loading of modules and submodules.
- ⌨️ Allows setting keymaps to lazily load the required module on press,
while retaining normal functionality.

Planned:

- Syncing together [lazy.nvim] `cmd` and
`keys` options.
- Support for other plugin managers.

## 🔧 Requirements

- [Neovim] >= **0.7.0** (to use vim.keymap)

[lazy.nvim] is recommended for that true lazy loading experience.

## ⚙️ Configuration

Coming soon in order to configure towards different plugin managers.


## 💡 Usage

It is highly recommended to have a separate location where plugins are loaded,
as it will allow you to require this plugin at the top scope.

This example will be using [lazy.nvim], if you would like to see another module
loader you are welcome to contribute.

For a more practical example see my full
[configuration](https://gitlab.com/dotfyls/neovim) (Github
[mirror](https://github.com/Xarvex/dotfyls-neovim)).


#### Initialization

In `init.lua` or wherever you load [lazy.nvim], change:

```lua
-- this assumes loading from a directory named plugin

require("lazy").setup("plugin")
-- or
require("lazy").setup({{ import = "plugin" }})
```

To:

```lua
-- must load before use in loading other plugins
-- to use specific release use tag, this version would be tag = "0.1.0"
-- you are welcome to use main, but I am not responsible for broken configs

require("lazy").setup({
    { "https://gitlab.com/xarvex/lazy-load.nvim", branch = "0.1.x", lazy = true },
    { import = "plugin" }
})
-- or (uses GitHub mirror, kept up to date)
require("lazy").setup({
    { "xarvex/lazy-load.nvim", branch = "0.1.x", lazy = true },
    { import = "plugin" }
})
```


#### Calling

Where you are loading other plugins, Well shown when using
[harpoon](https://github.com/ThePrimeagen/harpoon):

```lua
local lazy_load = require("lazy-load")
-- <...>
{
    "ThePrimeagen/harpoon",
    lazy = true,
    
    -- tables returned are in the format { <keymap>, <command> } for use with lazy.nvim
    keys = {
        -- both of these ways can be used to call
        lazy_load:keymap_require("n", "<leader>a", "harpoon.mark", "add_file"),
        lazy_load:keymap_require("n", "<leader>h", "harpoon.ui",
        function(ui) ui.toggle_quick_menu() end),

        -- different ways to pass variables
        lazy_load:keymap_require("n", "<leader>1", "harpoon.ui", "nav_file", 1),
        lazy_load:keymap_require("n", "<leader>2", "harpoon.ui",
        function(ui) ui.nav_file(2) end),
        lazy_load:keymap_require("n", "<leader>3", "harpoon.ui",
        function(ui, num) ui.nav_file(num) end, 3),
    }
}
```

You can even incrementally require a module in parts, useful when a plugin
has several submodules to it:

```lua
-- creates scope to use module "harpoon" lazily
local lazy_harpoon = require("lazy-load"):require("harpoon") -- "harpoon"
-- appends to lazily-required "harpoon" module with "ui"
local lazy_harpoon_ui = lazy_harpoon:require("ui") -- "harpoon.ui"
-- <...>
{
    "ThePrimeagen/harpoon",
    lazy = true, 
    keys = {
        -- "harpoon.mark"
        lazy_harpoon:keymap_require("n", "<leader>a", "mark", "add_file"),
        -- "harpoon.ui"
        lazy_harpoon:keymap_require("n", "<leader>h", "ui",
        function(ui) ui.toggle_quick_menu() end),

        -- no modification to module ("harpoon.ui")
        lazy_harpoon_ui:keymap_require("n", "<leader>1", "", "nav_file", 1),
        lazy_harpoon_ui:keymap_require("n", "<leader>2", nil,
        function(ui) ui.nav_file(2) end),
        lazy_harpoon_ui:keymap_require("n", "<leader>3", nil,
        function(ui, num) ui.nav_file(num) end, 3),
    }
}
```

Again, you may see my full [configuration](https://gitlab.com/dotfyls/neovim)
(Github [mirror](https://github.com/Xarvex/dotfyls-neovim)) to see how this can
efficiently be leveraged.


### 📃 License

_This project is licensed under **Mozilla Public License 2.0**._

[Neovim]: https://neovim.io
[lazy.nvim]: https://github.com/folke/lazy.nvim
