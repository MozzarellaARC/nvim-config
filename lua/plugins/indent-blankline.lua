return {
	"lukas-reineke/indent-blankline.nvim",
	opts = {
		indent = {
			char = "▎",
		},
		-- whitespace = {
		-- 	char = "┇",
		-- },
		--
		--
		--
	},
	config = function(_, opts)
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}
		vim.tbl_extend("force", opts, {
			-- options that for some reason you couldn't add in the opts field table
		})

		require("ibl").setup(opts)
	end,
}
