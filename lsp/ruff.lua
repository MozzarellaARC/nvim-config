return {
	vim.lsp.config("ruff", {
		cmd = { "ruff", "server" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
		init_options = {
			settings = {
				configurationPreference = "editorOnly",
				exclude = { "bpy" },
				-- logLevel = "debug",
				organizeImports = false,
				lint = {
					ignore = { "F403" },
				},
			},
		},
	}),
}
