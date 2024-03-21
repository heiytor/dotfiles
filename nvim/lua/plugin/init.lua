vim.cmd([[packadd packer.nvim]])

local function require_plugins()
	require("plugin.autopairs")
	require("plugin.comment")
	require("plugin.formatter")
	require("plugin.fugitive")
	require("plugin.gitsigns")
	require("plugin.harpoon")
	require("plugin.ibl")
	require("plugin.lsp")
	require("plugin.lualine")
	require("plugin.telescope")
	require("plugin.treesitter")
	require("plugin.undotree")
	require("plugin.theme")
end

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	---------
	-- LSP --
	---------

	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{ "williamboman/mason.nvim" }, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Format Support
			{ "mhartington/formatter.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" }, -- Required
		},
	})

	------------
	-- Themes --
	------------

	-- use("nyoom-engineering/oxocarbon.nvim")
	-- use("projekt0n/github-nvim-theme")
	-- use("datsfilipe/min-theme.nvim")

	-- Minimal
	use("axvr/photon.vim")
	-- use("huyvohcmc/atlas.vim")

	------------
	-- Editor --
	------------

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use("lukas-reineke/indent-blankline.nvim")
	use("windwp/nvim-autopairs")
	use("mbbill/undotree")
	use("lewis6991/gitsigns.nvim")
	use("numToStr/Comment.nvim")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-context")

	--------------
	-- Movement --
	--------------

	use("ThePrimeagen/harpoon")
	use("tpope/vim-fugitive")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		requires = {
			{ "nvim-lua/plenary.nvim" },
		},
	})

	require_plugins()
end)
