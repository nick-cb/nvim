return {
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			require("rainbow-delimiters.setup").setup({
				strategy = {},
				query = {
					tsx = "rainbow-parens",
				},
				highlight = {
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
					"RainbowDelimiterYellow",
					"RainbowDelimiterRed",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
				},
				blacklist = { "sql", "markdown", "ejs", "html" },
			})
		end,
	},
}
