local M = {}

--- Sets up a keymap to lazily require a module command.
--- 
--- The keymap is mapped to a function that when executed, will require
--- the module, get the relevent command, and set the keymap for itself,
--- then executing that command.
---
--- Because of this behavior, that original function will only run one time.
---
---@param mode string|table What mode to be active in.
---@param keymap string Keyboard-combination.
---@param module_name string Module name (as it would appear in require call).
---@param accessor string|function Command to execute.
---         If a string, key to the module element. If a function, passed with
---         module and varargs as parameters.
---@param ... any Arguments passed to the module function.
function M.keymap_require(mode, keymap, module_name, accessor, ...)
    local args = ... -- args passed to command
    return { -- table that lazy.nvim expects
        keymap,
        function()
            local module = require(module_name)
            local call
            if (type(accessor) == "string") then
                local command = module[accessor]
                call = args == nil and command or function()
                    command(args)
                end -- only create wrapper function if varargs being passed
            else
                call = function()
                    accessor(module, args)
                end
            end
            vim.keymap.set(mode, keymap, call) -- set keybind for self
            if (type(call) == "function") then -- call command
                call()
            else
                vim.cmd(call) -- call must be string command
            end
        end
    }
end

return M
