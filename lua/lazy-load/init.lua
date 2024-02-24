---@class Module
---@field module? string
local M = {}

---@param name1 string|nil
---@param name2 string|nil
---@return string combined
local function combine_module_name(name1, name2)
    if name1 == nil then
        return name2 ~= nil and name2 or ""
    end
    if name2 == nil then
        return name1
    end
    return name1 .. (name1 ~= "" and name2 ~= "" and "." or "") .. name2
end

---@param module_name string|nil Module name as it would appear in a require.
---        A nil or empty string can be used to reset the value.
---@return Module self
function M:set_require(module_name)
    local module = {}
    for k, v in pairs(self) do
        module[k] = v
    end
    module.module = module_name
    return module
end

---@param module_name string Module name as it would appear in a require.
---@return Module self
function M:require(module_name)
    return self:set_require(combine_module_name(self.module, module_name))
end

---@param module_name string|nil Module name as it would appear in a require.
---         Can only be nil or empty if module is stored from previous require
---         or set_require.
---@return unknown module from require call
---@return unknown loaderdata from require call
function M:load(module_name)
    return require(combine_module_name(self.module, module_name))
end

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
---@param module_name string|nil Module name as it would appear in a require.
---         Can only be nil or empty if module is stored from previous require
---         or set_require.
---@param accessor string|function Command to execute.
---         If a string, key to the module element. If a function, passed with
---         module and varargs as parameters.
---@param ... unknown Arguments passed to the module function.
---@return table
function M:keymap_require(mode, keymap, module_name, accessor, ...)
    local args = ... -- args passed to command
    return {         -- table that lazy.nvim expects
        keymap,
        function()
            local module = self:load(module_name)
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
