return {
	vim.lsp.config("copilot", {
		cmd = { "copilot-language-server", "--stdio" },
		root_markers = { ".git" },
		settings = {
			telemetry = {
				telemetryLevel = "none",
			},
		},
	}),
}
