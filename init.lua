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

-- Define diagnostic signs for the gutter
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

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
			border = { " " },
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

-- Auto-reload files changed outside of Neovim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	pattern = "*",
	command = "checktime",
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
	end,
})

-- Set updatetime for CursorHold (default is 4000ms, this makes it faster)
vim.opt.updatetime = 500

-- LSP
vim.lsp.enable("lua_ls")
vim.lsp.enable("pwsh")
vim.lsp.enable("copilot")
vim.lsp.inline_completion.enable()

-- Provider
vim.g.python3_host_prog = "C:/Users/M/scoop/shims/python313.exe"

-- Disable netrw (use oil.nvim instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Editor
vim.opt.tabstop = 4 -- How many columns a tab counts for
vim.opt.softtabstop = 4 -- How many spaces a tab feels like in insert mode
vim.opt.shiftwidth = 4 -- How many spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.cindent = true -- Indentation style for C-like languages
vim.opt.number = true -- Show absolute line numbers

-- Gutter/Sign Column
-- vim.opt.signcolumn = "yes" -- Always show sign column to prevent text shifting
-- vim.opt.numberwidth = 4 -- Width of the number column

-- Cache optimization
vim.o.swapfile = false
vim.opt.autoread = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")

-- Highlight matching pairs with a block background so the characters stay readable
local function set_matchparen_highlight()
	local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
	vim.api.nvim_set_hl(0, "MatchParen", {
		bg = "#D7D6CE",
		fg = visual_hl.bg,
		bold = true,
	})
end
set_matchparen_highlight()
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_matchparen_highlight,
})
