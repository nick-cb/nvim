local M = {}

M.setup = function()
	local ok, trouble = pcall(require, "trouble")
	if not ok then
		return
	end
	trouble.setup({
    auto_refresh = false,
		modes = {
			lsp_references = {
				filter = {
					function(item)
						return item.client ~= "tsserver"
					end,
				},
			},
			lsp_definitions = {
				filter = {
					function(item)
						return item.client ~= "tsserver"
					end,
				},
			},
		},
	})
end

return M
