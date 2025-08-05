return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.pairs").setup()
		require("mini.misc").setup()

		-- Auto root to the directory of the current buffer
		require("mini.misc").setup_auto_root()
	end,
}
