local M = {}

--- Sets the Neovim leader key.
---@param key string
M.set_leader = function(key)
	vim.g.mapleader = key
end

--- Sets a key.
---@param k table
M.set = function(k)
	vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
end

--- Sets N keys. Optionally, sets default options for each key.
---
---@param keys table The list of key bindings.
---@param opts table Optional table of default options to be applied to each key binding.
M.setN = function(keys, opts)
	for _, k in ipairs(keys) do
		if opts then
			for o_k, o_v in pairs(opts) do
				k[o_k] = o_v
			end
		end

		vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
	end
end

--- Prepends the toggle key to the given key.
---@param key string
M.toggle = function(key)
	return "t" .. key
end

--- Prepends the leader key to the given key.
---@param key string
M.leader = function(key)
	return "<leader>" .. key
end

--- Prepends the control modifier to the given key.
---@param key string
M.ctrl = function(key)
	return "<C-" .. key .. ">"
end

--- Prepends the shift modifier to the given key.
---@param key string
M.shift = function(key)
	return "<S" .. key .. ">"
end

return M
