return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		require("bufferline").setup({
			options = {
				numbers = "ordinal",
				show_close_icon = false,
				persist_buffer_sort = true,
				separator_style = "slope",

				-- tab_size = 3,
				--
				--test3

				diagnostic = true,
				diagnostic_update_in_insert = true,
				diagnostic_update_on_event = true,

				--test

				hover = {
					enabled = true,
					delay = 200,
					reveal = { "close" },
				},
			},
		})
	end,
}
