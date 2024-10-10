local M = {}

--- Prepends the toggle key to the given key.
--@param key string
M.toggle = function(key)
    return "t" .. key
end

--- Prepends the leader key to the given key.
--@param key string
M.leader = function(key)
    return "<leader>" .. key
end

--- Prepends the control modifier to the given key.
--@param key string
M.ctrl = function(key)
    return "<C-" .. key .. ">"
end

--- Prepends the shift modifier to the given key.
--@param key string
M.shift = function(key)
    return "<S" .. key .. ">"
end

--- Sets a key.
--@param k table
M.map = function(k)
    local modes = type(k.mode) == "table" and k.mode or { k.mode }
    local lhs_keys = type(k.lhs) == "table" and k.lhs or { k.lhs }

    for _, mode in ipairs(modes) do
        for _, lhs in ipairs(lhs_keys) do
            vim.keymap.set(mode, lhs, k.rhs, k.opts)
        end
    end
end

--- Sets N keys. Optionally, sets default options for each key.
--
--@param keys table The list of key bindings.
--@param opts table Optional table of default options to be applied to each key binding.
M.map_table = function(keys, opts)
    for _, k in ipairs(keys) do
        if opts then
            for o_k, o_v in pairs(opts) do
                k[o_k] = o_v
            end
        end

        vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
    end
end

return M
