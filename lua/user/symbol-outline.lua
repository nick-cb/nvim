local M = {}

M.config = function()
	local status_ok, symbols = pcall(require, "symbols-outline")
	if not status_ok then
		return
	end
	symbols.setup({
		autofold_depth = 3,
		auto_unfold_hover = true,
		symbols = {
			Interface = { icon = "", hl = "CmpItemKindInterface" },
			Field = { icon = "", hl = "CmpItemKindField" },
			Variable = { icon = "", hl = "CmpItemKindVariable" },
			Function = { icon = "", hl = "CmpItemKindFunction" },
			Property = { icon = "", hl = "CmpItemKindProperty" },
		},
	})
end

return M
