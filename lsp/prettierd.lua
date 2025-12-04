return {
	vim.lsp.config("prettierd", {
		cmd = "prettierd",
		filetypes = { "json" },
		root_markers = {
			"*.json",
		},
	}),
}
