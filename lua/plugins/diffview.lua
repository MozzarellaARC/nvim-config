return {
	"sindrets/diffview.nvim",

	config = function()
		require("diffview").setup({
			keymaps = {},
			view = {
				file_history = {
					layout = "diff2_horizontal",
					winbar_info = false,
				},
			},
			file_panel = {
				listing_style = "tree",
				win_config = {
					position = "left",
					width = 35,
				},
			},
			file_history_panel = {
				log_options = {
					git = {
						single_file = {
							diff_merges = "first-parent",
						},
					},
				},
				win_config = {
					position = "left",
					width = 35,
				},
			},
		})
	end,
}
