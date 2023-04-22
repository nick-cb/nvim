local M = {}

M.config = function()
	local status_ok, telescope_tab = pcall(require, "telescope-tabs")
	if not status_ok then
		return
	end
	telescope_tab.setup({
		theme = "dropdown",
		show_preview = false,
		entry_formatter = function(_, tab_index, _, _, file_paths)
			local new_file_names = {}
			for _, value in ipairs(file_paths) do
				if not string.find(value, "NvimTree") and value ~= nil and value ~= "" then
					local strs = require("user.utils").split_str(value, "/")
					table.insert(new_file_names, strs[#strs - 1] .. "/" .. strs[#strs])
				end
			end
			local entry_string = table.concat(new_file_names, ", ")
			return string.format("%d: %s", tab_index, entry_string)
		end,
		ordinal_formatter = function(_, tab_index, _, _, file_paths)
			local new_file_names = {}
			for _, value in ipairs(file_paths) do
				if not string.find(value, "NvimTree") and value ~= nil and value ~= "" then
					table.insert(new_file_names, value)
				end
			end
			local entry_string = table.concat(new_file_names, ", ")
			return string.format("%d: %s", tab_index, entry_string)
		end,
	})
end

return M
