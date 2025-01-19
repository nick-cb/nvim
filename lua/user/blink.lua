local M = {}

M.setup = function()
	local ok, blink = pcall(require, "blink-cmp")
	if not ok then
		return
	end

	blink.setup({
		-- highlight = {
		-- 	use_nvim_cmp_as_default = true,
		-- },
		-- nerd_font_variant = "normal",
		-- sources = {
		-- 	providers = {
		-- 		lsp = {
		-- 			name = "LSP",
		-- 			module = "blink.cmp.sources.lsp",
		-- 			-- fallbacks = { "buffer" },
		-- 			transform_items = function(_, items)
		-- 				-- demote snippets
		-- 				for _, item in ipairs(items) do
		-- 					if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
		-- 						item.score_offset = item.score_offset - 3
		-- 					end
		-- 				end

		-- 				-- filter out text items, since we have the buffer source
		-- 				return vim.tbl_filter(function(item)
		-- 					return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
		-- 				end, items)
  --           -- return items
		-- 			end,
		-- 		},
		-- 		path = {
		-- 			name = "Path",
		-- 			module = "blink.cmp.sources.path",
		-- 			score_offset = 3,
		-- 			-- fallbacks = { "buffer" },
		-- 		},
		-- 		snippets = {
		-- 			name = "Snippets",
		-- 			module = "blink.cmp.sources.snippets",
		-- 			score_offset = -3,
		-- 		},
		-- 		luasnip = {
		-- 			name = "Luasnip",
		-- 			module = "blink.cmp.sources.luasnip",
		-- 			score_offset = -3,
		-- 		},
		-- 		buffer = {
		-- 			name = "Buffer",
		-- 			module = "blink.cmp.sources.buffer",
  --         enabled = true,
  --         should_show_items = true,
		-- 			-- score_offset = -3,
		-- 		},
		-- 		cmdline = {
		-- 			name = "cmdline",
		-- 			module = "blink.cmp.sources.cmdline",
		-- 		},
		-- 	},
		-- },
		completion = {
			list = {
				selection = "auto_insert",
			},
		},
		keymap = {
			["<CR>"] = {
				function(cmp)
					cmp.accept()
				end,
				"fallback",
			},
			["<Tab>"] = {
				"select_next",
				"fallback",
			},
			["<S-Tab>"] = {
				-- function(cmp)
				--   if cmp.snippet_active() then return cmp.accept()
				--   else return cmp.select_and_accept() end
				-- end,
				"select_prev",
				"fallback",
			},
		},
		-- windows = {
		-- 	autocomplete = {
		-- 		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
		-- 	},
		-- 	documentation = {
		-- 		border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
		-- 		update_delay_ms = 0,
		-- 		auto_show_delay_ms = 100,
		-- 	},
		-- },
	})
end

return M
