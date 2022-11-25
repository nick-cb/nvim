local M = {}

M.toggle_tree = function()
	if vim.o.columns > 120 then
		vim.g.netrw_winsize = 20
    vim.cmd('Lexplore')
	else
		vim.g.netrw_winsize = 40
    vim.cmd('Lexplore')
	end
end

return M
