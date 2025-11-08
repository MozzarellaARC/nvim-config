return {
	"CopilotC-Nvim/CopilotChat.nvim",
	enable = false,
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	opts = {
		model = "gpt-4.1", -- AI model to use
		temperature = 0.1, -- Lower = focused, higher = creative

		window = {
			layout = "vertical", -- 'vertical' = right side, 'horizontal' = bottom, 'float' = floating
			width = 0.25, -- 50% of screen width
			border = "rounded", -- 'single', 'double', 'rounded', 'solid', 'none'
			title = "🤖 AI Assistant",
			relative = "editor", -- Position relative to editor
		},

		headers = {
			user = "👤 You",
			assistant = "🤖 Copilot",
			tool = "🔧 Tool",
		},

		separator = "━━",
		auto_insert_mode = false, -- Don't enter insert mode when opening
		auto_fold = false, -- Automatically folds non-assistant messages
	},

	-- Auto-command to customize chat buffer behavior
	config = function(_, opts)
		require("CopilotChat").setup(opts)

		-- Keymap to toggle chat with F5 using unified view system
		vim.keymap.set(
			{ "n", "v" },
			"<F5>",
			function()
				-- Use the global toggle_view function if available
				if _G.toggle_view then
					_G.toggle_view("copilot", function()
						local chat = require("CopilotChat")
						chat.open()
						-- Move window to the right
						vim.cmd("wincmd L")
						vim.wo.wrap = false
					end)
				end
			end --, { desc = "Toggle Copilot Chat", silent = true }
		)

		-- Ensure wrap stays off when switching windows
		vim.api.nvim_create_autocmd("WinEnter", {
			callback = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if not bufname:match("copilot%-") then
					vim.wo.wrap = false
				end
			end,
		})
	end,
}
