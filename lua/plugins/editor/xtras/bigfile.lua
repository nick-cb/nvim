return {
	{
		"LunarVim/bigfile.nvim",
		config = function()
			require("bigfile").setup({
				filesize = 0.4,
				pattern = { "*" },
				features = {
					"indent_blankline",
					"illuminate",
					"lsp",
					"matchparen",
					"vimopts",
					"filetype",
				},
			})
		end,
	},
}
