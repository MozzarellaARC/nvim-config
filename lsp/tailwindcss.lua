local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("tailwindcss", {
	root_markers = { ".git" },
	filetypes = { "*" },
	capabilities = capabilities,
})
