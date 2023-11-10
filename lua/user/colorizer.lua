local M = {}

M.config = function()
	local status_ok, colorizer = pcall(require, "colorizer")
	if not status_ok then
		return
	end

	colorizer.setup({ "*" }, {
		RGB = true, -- #RGB hex codes
		RRGGBB = true, -- #RRGGBB hex codes
		RRGGBBAA = true, -- #RRGGBBAA hex codes
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
		css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
	})
end

return M

-- #4C566A
-- #4C566A
-- #D16969
-- #D16969
-- #6A9955
-- #6A9955
-- #C68A75
-- #D7BA7D
-- #569CD6
-- #569CD6
-- #D16D9E
-- #D16D9E
-- #4EC9B0
-- #4EC9B0
-- #abb2bf
-- #abb2bf
