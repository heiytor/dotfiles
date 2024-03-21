-- See:
-- > https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
local opts = {
	settings = {
		["rust-analyzer"] = {
			inlayHints = {
				maxLength = 25,
			},
		},
	},
}

return opts
