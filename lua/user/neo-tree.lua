local icons = require("user.icons")

local M = {}

M.setup = function()
	local ok, neotree = pcall(require, "neo-tree")
	if not ok then
		return
	end
	neotree.setup({
    default_component_configs = {
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = icons.git.FileDeleted,
          renamed = icons.git.FileRenamed,
          untracked = icons.git.FileUntracked,
          ignored = icons.git.FileIgnored,
          conflict = icons.git.FileUnmerged,
          untagged = icons.git.FileUnstaged,
          staged = icons.git.FileStaged,
        }
      }
    },
		window = {
			mappings = {
				["l"] = "open",
        ['h'] = "close"
			},
		},
	})
end

return M
