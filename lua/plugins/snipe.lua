return {
	"leath-dub/snipe.nvim",
	config = function()
		local snipe = require("snipe")

		snipe.setup({
			hints = {
				-- Use numbers instead of letters for marks
				dictionary = "1234567890",
			},
		})

		vim.keymap.set("n", "<leader>`", snipe.open_buffer_menu)
	end,
}
