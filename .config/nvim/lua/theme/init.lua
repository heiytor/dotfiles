local function disable_background()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

local function load()
	-- The current theme is expected to be a file called "current.lua". The file
	-- will be evaluated if exists.
	local current_theme = os.getenv("HOME") .. "/.config/nvim/lua/theme/current.lua"
	if vim.loop.fs_stat(current_theme) then
		dofile(current_theme)
	end
end

disable_background()
load()
