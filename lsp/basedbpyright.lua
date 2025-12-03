return {
	vim.lsp.config("basedpyright", {
		cmd = { "basedpyright-langserver", "--stdio" },
		filetype = { "python" },
		root_markers = {
			"pyproject.toml",
			"blener_manifest.toml",
			"LICENSE",
			"README.md",
			".git",
		},
		settings = {
			basedpyright = {
				analysis = {
					autoImportCompletions = true,
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					typeCheckingMode = "basic", -- standard, strict, all, off, basic
					reportMissingImports = {
						exclude = "bpy",
					},
				},
				-- python = { venvPath = ".venv/bin/python" }, -- this is a bad config
			},
		},
	}),
}
