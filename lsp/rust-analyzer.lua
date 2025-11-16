return {
	vim.lsp.config("rust_analyzer", {
		{ "rust-analyzer" },
		{ "rust" },
		capabilities = {
			{
				experimental = {
					commands = {
						commands = {
							"rust-analyzer.showReferences",
							"rust-analyzer.runSingle",
							"rust-analyzer.debugSingle",
						},
					},
					serverStatusNotification = true,
				},
			},
		},
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
				},
			},
		},
	}),
}
