return {
	vim.lsp.config("ruff", {
		cmd = { "ruff", "server" },
		filetypes = { "python", ".py" },
		root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git", "main.py", "__init__.py" },
		init_options = {
			settings = {
				configurationPreference = "filesystemFirst",
				exclude = { "bpy" },
				logLevel = "debug",
				organizeImports = true,
				lint = {
					enable = true,
				},
				format = {
					preview = true,
					backend = "uv",
				},
			},
		},
	}),
}
