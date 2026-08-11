return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false, -- o main nao suporta lazy-loading
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.install({
				"vim",
				"vimdoc",

				"lua",
				"luadoc",

				"bash",

				"go",
				"gomod",
				"gosum",
				"gotmpl",
				"gowork",

				"nginx",

				"markdown",
				"markdown_inline",

				"javascript",
				"typescript",
				"html",

				"c",
				"cpp",

				"rust",
				"json",

				"ruby",

				"python",
			})

			local max_filesize = 100 * 1024 -- 100 KB

			-- no main nada e habilitado automaticamente: highlight e indent
			-- precisam ser ligados por buffer
			local function start(buf, lang)
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					vim.notify(
						"File larger than 100KB treesitter disabled for performance",
						vim.log.levels.WARN,
						{ title = "Treesitter" }
					)

					return
				end

				vim.treesitter.start(buf, lang)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				if vim.bo[buf].filetype == "markdown" then
					vim.bo[buf].syntax = "on"
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
					if not lang then
						return
					end

					if vim.treesitter.language.add(lang) then
						start(args.buf, lang)
						return
					end

					-- equivalente ao auto_install do branch master
					if not vim.tbl_contains(ts.get_available(), lang) then
						return
					end

					ts.install(lang):await(function()
						vim.schedule(function()
							if vim.api.nvim_buf_is_valid(args.buf) and vim.treesitter.language.add(lang) then
								start(args.buf, lang)
							end
						end)
					end)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				multiwindow = false,
				max_lines = 0,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = nil,
			})
		end,
	},
}
