local async = require("blink.cmp.lib.async")
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
			local bufnr = vim.api.nvim_get_current_buf()
			local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")

			vim.system({ "ruff", "format", "-" }, { stdin = text }, function(obj)
				if obj.code == 0 and obj.stdout then
					local formatted = vim.split(obj.stdout, "\n", { plain = true })
					vim.schedule(function()
						vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
					end)
				end
			end)
		end,
	}),
}
