return {
	{
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({

				ui = {
					border = "solid",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				pip = {
					---@since 1.0.0
					-- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
					upgrade_pip = true,

					---@since 1.0.0
					-- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
					-- and is not recommended.
					--
					-- Example: { "--proxy", "https://proxyserver" }
					install_args = {},
				},
			})
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason-lspconfig").setup({

				ensure_installed = {
					"lua_ls",
					"vimls",
					"rust_analyzer",
					"pyright",
					"copilot",
					"powershell_es",
					"cssls",
					"tailwindcss",
				},
				automatic_enable = {
					"lua_ls",
					"vimls",
				},
			})
		end,
	},
}
