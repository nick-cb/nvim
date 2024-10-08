local M = {}

M.setup = function()
	local ok, blink = pcall(require, "blink-cmp")
	if not ok then
		return
	end
	vim.print(ok, blink)

	blink.setup({
		highlight = {
			use_nvim_cmp_as_default = true,
		},
		nerd_font_variant = "normal",
		keymap = {
			accept = { "<CR>", "<TAB>" },
		},
		windows = {
			autocomplete = {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
			},
			documentation = {
				border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
				update_delay_ms = 0,
				auto_show_delay_ms = 100,
			},
		},
	})
end

return M
