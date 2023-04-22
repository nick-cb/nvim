local icons = require("user.icons")

local M = {}

local config = {
	options = {
		enabled = true,
		buftype_exclude = { "terminal", "nofile" },
		filetype_exclude = {
			"help",
			"startify",
			"dashboard",
			"lazy",
			"neogitstatus",
			"NvimTree",
			"Trouble",
			"text",
		},
		char = icons.ui.LineLeft,
		context_char = icons.ui.LineLeft,
		show_trailing_blankline_indent = false,
		show_first_indent_level = true,
		use_treesitter = true,
		show_current_context = true,
	},
}

M.setup = function()
	local ok, indent_blankline = pcall(require, "indent_blankline")

	if not ok then
		return
	end

	indent_blankline.setup(config)
end

return M
