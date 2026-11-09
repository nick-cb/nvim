-- Open Claude with the given config dir, or the default one when nil. The plugin keeps
-- the `env` table from opts and reads it on every launch, so changing it here applies
-- to the next Claude it starts. A Claude that is already running keeps its account.
-- Expand `~` up front: the env reaches the Rex pane as `env KEY=VALUE` arguments, and
-- no shell expands them.
local function launch_claude(config_dir)
	require("claudecode").state.config.env.CLAUDE_CONFIG_DIR = config_dir and vim.fn.expand(config_dir)
	vim.cmd("ClaudeCodeOpen")
end

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		terminal_cmd = "claude",
		-- `launch_claude` below sets or clears CLAUDE_CONFIG_DIR in this table per launch.
		env = {},
		terminal = {
			split_side = "right", -- "left" or "right"
			split_width_percentage = 0.40,
			-- Optional: shrink (or widen) the terminal while a diff is open. Defaults to
			-- split_width_percentage when unset, preserving today's behavior.
			diff_split_width_percentage = nil, -- e.g. 0.20 to give diffs more room
			-- Inside Rex, open Claude in a Rex pane beside Neovim; elsewhere use a normal split.
			provider = vim.env.REX_BLOCK and "external" or "auto", -- "auto", "snacks", "native", "external", "none", or custom provider table
			auto_close = true,
			-- Auto-enter insert/terminal mode whenever the Claude terminal window gains
			-- focus. Set to false to stay in Normal mode and preserve your scroll position
			-- when switching back to the terminal (e.g. via <C-w>l); press `i` to type.
			-- Note: false also opens the terminal in Normal mode (it gates start-insert too).
			auto_insert = true,
			snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
			-- Work around a Neovim core bug (< 0.12.2) that fragments large pastes into
			-- the terminal, making Cmd+V appear to truncate ([#161]). true | false | "auto"
			-- ("auto", the default, enables it only on affected Neovim versions).
			fix_streamed_paste = "auto",

			-- Provider-specific options
			provider_opts = {
				-- Command for external terminal provider. Can be:
				-- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
				-- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
				-- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
				-- The Rex pane is started by the Rex server, so the plugin's env (SSE port,
				-- IDE integration) must be passed in the command via `env`. `--wait` keeps
				-- the job alive until Claude exits so the plugin tracks its state.
				external_terminal_cmd = function(cmd, env)
					local argv = {
						"rex",
						"split",
						"-s",
						vim.env.REX_SESSION,
						"-b",
						vim.env.REX_BLOCK,
						"--split=right",
						"--ratio",
						"40",
						"-c",
						vim.fn.getcwd(),
						"--label",
						"Claude",
						"--wait",
						"--",
						"env",
					}
					for k, v in pairs(env) do
						table.insert(argv, k .. "=" .. v)
					end
					vim.list_extend(argv, { "sh", "-c", cmd })
					return argv
				end,
			},
		},
	},
	-- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
	-- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
	-- spec defers loading until a <leader>a* mapping is pressed and the commands
	-- would not exist yet.
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffs",
	},
	keys = {
		{ "<leader>a", nil, desc = "AI/Claude Code" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		-- Same as the `c1` shell alias: `CLAUDE_CONFIG_DIR=~/.claude-2 claude`.
		{ "<leader>aa", function() launch_claude("~/.claude-2") end, desc = "Launch Claude (.claude-2)" },
		{ "<leader>as", function() launch_claude(nil) end, desc = "Launch Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>ac", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
		},
		-- Diff management
		-- { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		-- { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
}
