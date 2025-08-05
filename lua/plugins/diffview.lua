return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({
			-- view = {
			-- 	-- Configure the layout and behavior of different types of views.
			-- 	default = {
			-- 		-- Config for changed files, and staged files in diff views.
			-- 		layout = "diff2_horizontal",
			-- 		winbar_info = false,
			-- 	},
			-- 	merge_tool = {
			-- 		-- Config for conflicted files in diff views during a merge or rebase.
			-- 		layout = "diff3_horizontal",
			-- 		disable_diagnostics = true,
			-- 		winbar_info = true,
			-- 	},
			-- 	file_history = {
			-- 		-- Config for changed files in file history views.
			-- 		layout = "diff2_horizontal",
			-- 		winbar_info = false,
			-- 	},
			-- },
			keymaps = {
				view = {
					-- Add synchronized scrolling keymaps
					{
						"n",
						"<C-d>",
						function()
							-- Scroll down in both buffers
							vim.cmd("normal! \\<C-d>")
							vim.cmd("wincmd w")
							vim.cmd("normal! \\<C-d>")
							vim.cmd("wincmd w")
						end,
						{ desc = "Scroll down in both diff buffers" },
					},
					{
						"n",
						"<C-u>",
						function()
							-- Scroll up in both buffers
							vim.cmd("normal! \\<C-u>")
							vim.cmd("wincmd w")
							vim.cmd("normal! \\<C-u>")
							vim.cmd("wincmd w")
						end,
						{ desc = "Scroll up in both diff buffers" },
					},
					{
						"n",
						"<C-f>",
						function()
							-- Page down in both buffers
							vim.cmd("normal! \\<C-f>")
							vim.cmd("wincmd w")
							vim.cmd("normal! \\<C-f>")
							vim.cmd("wincmd w")
						end,
						{ desc = "Page down in both diff buffers" },
					},
					{
						"n",
						"<C-b>",
						function()
							-- Page up in both buffers
							vim.cmd("normal! \\<C-b>")
							vim.cmd("wincmd w")
							vim.cmd("normal! \\<C-b>")
							vim.cmd("wincmd w")
						end,
						{ desc = "Page up in both diff buffers" },
					},
					{
						"n",
						"j",
						function()
							-- Move down in both buffers
							vim.cmd("normal! j")
							vim.cmd("wincmd w")
							vim.cmd("normal! j")
							vim.cmd("wincmd w")
						end,
						{ desc = "Move down in both diff buffers" },
					},
					{
						"n",
						"k",
						function()
							-- Move up in both buffers
							vim.cmd("normal! k")
							vim.cmd("wincmd w")
							vim.cmd("normal! k")
							vim.cmd("wincmd w")
						end,
						{ desc = "Move up in both diff buffers" },
					},
					{
						"n",
						"gg",
						function()
							-- Go to top in both buffers
							vim.cmd("normal! gg")
							vim.cmd("wincmd w")
							vim.cmd("normal! gg")
							vim.cmd("wincmd w")
						end,
						{ desc = "Go to top in both diff buffers" },
					},
					{
						"n",
						"G",
						function()
							-- Go to bottom in both buffers
							vim.cmd("normal! G")
							vim.cmd("wincmd w")
							vim.cmd("normal! G")
							vim.cmd("wincmd w")
						end,
						{ desc = "Go to bottom in both diff buffers" },
					},
				},
			},
		})
	end,
}
