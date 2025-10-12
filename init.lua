vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

-- Configure inline diagnostics (Neovim 0.10+)
vim.diagnostic.config({
	virtual_text = false, -- Disable end-of-line virtual text
	virtual_lines = false,
	signs = true, -- Keep signs in the gutter
	underline = true, -- Underline errors
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

-- Enable inline diagnostics (Neovim 0.10+)
vim.diagnostic.config({
	virtual_text = {
		prefix = "",
		suffix = "",
		format = function(diagnostic)
			return string.format(" %s", diagnostic.message)
		end,
	},
})

-- Show diagnostics on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			-- Custom border characters: top-left, top, top-right, right, bottom-right, bottom, bottom-left, left
			border = { " "
				-- { "┏", "FloatBorder" },
				-- { "━", "FloatBorder" },
				-- { "┓", "FloatBorder" },
				-- { "┃", "FloatBorder" },
				-- { "┛", "FloatBorder" },
				-- { "━", "FloatBorder" },
				-- { "┗", "FloatBorder" },
				-- { "┃", "FloatBorder" },
			},
			source = "always",
			prefix = " ",
			scope = "cursor",
			header = { " Diagnostics ", "DiagnosticHeader" },
			format = function(diagnostic)
				local severity = vim.diagnostic.severity[diagnostic.severity]
				local icon = ({
					ERROR = " ",
					WARN = " ",
					INFO = " ",
					HINT = " ",
				})[severity] or ""
				return string.format("%s %s", icon, diagnostic.message)
			end,
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

-- Set updatetime for CursorHold (default is 4000ms, this makes it faster)
vim.opt.updatetime = 500

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")
