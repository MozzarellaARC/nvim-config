local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("css-lsp", {
	root_markers = { ".git" },
	filetypes = { "*" },
	capabilities = capabilities,
})
