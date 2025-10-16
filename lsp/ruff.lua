return {
	vim.lsp.config("ruff", {
		cmd = { "ruff", "server" },
		filetypes = { "python", ".py" },
		root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git", "main.py" },
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
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.py",
		callback = function()
			vim.cmd("silent! %!ruff format -")
		end,
	}),
}
