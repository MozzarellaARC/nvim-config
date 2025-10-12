vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	root_marers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		python = {
			analysis = {
				-- Ignore specific modules like bpy
				ignore = { "bpy" },
				-- Optionally suppress stub warnings
				reportMissingTypeStubs = "none",
			},
		},
	},

})
