return {
	cmd = { "pyright" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git", "__init__.py" },
	settings = {
		python = {
			analysis = {
				exclude = { "**/bpy.py" },
			},
		},
	},
}
