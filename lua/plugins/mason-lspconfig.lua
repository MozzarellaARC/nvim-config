return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"stylua",
			"ruff",
			"prettierd",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
