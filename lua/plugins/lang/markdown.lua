return {
	{
		"OXY2DEV/markview.nvim",
		config = function()
			local presets = require("markview.presets")
			require("markview").setup({
				markdown = {
					headings = presets.headings.glow,
					list_items = {
						shift_width = 1,
						indent_size = 1,
					},
				},
			})
		end,
		ft = { "markdown" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
