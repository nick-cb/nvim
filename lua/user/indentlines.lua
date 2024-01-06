local icons = require("user.icons")

local M = {}

M.setup = function()
	local ok, indent_blankline = pcall(require, "ibl")

	if not ok then
		return
	end
	local hooks = require("ibl.hooks")
	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	end)

	indent_blankline.setup({
		indent = {
			char = icons.ui.LineMiddleDot,
			highlight = {
				"IndentBlanklineChar",
				-- 	"RainbowRed",
				-- 	"RainbowYellow",
				-- 	"RainbowBlue",
				-- 	"RainbowOrange",
				-- 	"RainbowGreen",
				-- 	"RainbowViolet",
				-- 	"RainbowCyan",
			},
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
			highlight = {
				"IndentBlanklineContextChar",
				-- "RainbowRed",
				-- "RainbowYellow",
				-- "RainbowBlue",
				-- "RainbowOrange",
				-- "RainbowGreen",
				-- "RainbowViolet",
				-- "RainbowCyan",
			},
		},
	})

	hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
