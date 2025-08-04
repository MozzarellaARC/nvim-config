return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- Common on_attach function for all LSP servers
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			end

			-- Setup language servers
			local lspconfig = require("lspconfig")
			-- Lua Language Server
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			-- C/C++ Language Server (clangd)
			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { "clangd", "--background-index" },
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			})

			-- Add more language servers as needed
			-- Example for Python:
			-- lspconfig.pyright.setup {
			--   capabilities = capabilities,
			--   on_attach = on_attach,
			-- }
			-- Example for TypeScript/JavaScript:
			-- lspconfig.ts_ls.setup {
			--   capabilities = capabilities,
			--   on_attach = on_attach,
			-- }
		end,
	},
}
