return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.pairs").setup()
		require("mini.misc").setup()
		require("mini.misc").setup_auto_root()
	end,
}
