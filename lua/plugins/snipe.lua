return {
	"leath-dub/snipe.nvim",
	config = function()
		local snipe = require("snipe")

		snipe.setup({
			hints = {
				-- Use numbers instead of letters for marks
				dictionary = "1234567890abcefgijklmnoprstuwxyz",
			},
			ui = {
				-- Where to place the ui window
				-- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
				---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
				position = "center",
				-- Override options passed to `nvim_open_win`
				-- Be careful with this as snipe will not validate
				-- anything you override here. See `:h nvim_open_win`
				-- for config options
				---@type vim.api.keyset.win_config
				open_win_override = {
					title = "Snipe",
					border = "solid", -- use "rounded" for rounded border
				},
			},
		})

		vim.keymap.set("n", "<leader>`", snipe.open_buffer_menu)
	end,
}
