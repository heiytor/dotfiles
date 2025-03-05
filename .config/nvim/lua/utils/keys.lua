local M = {}

---Prepends the leader key to the given key.
M.leader = function(key)
	return "<leader>" .. key
end

---Prepends the control modifier to the given key.
M.ctrl = function(key)
	return "<C-" .. key .. ">"
end

---Prepends the shift modifier to the given key.
M.shift = function(key)
	return "<S" .. key .. ">"
end

---Prepends the toggle key to the given key.
M.toggle = function(key)
	return "t" .. key
end

return M
