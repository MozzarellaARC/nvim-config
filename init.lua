vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
})

vim.opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
vim.cmd.colorscheme("kanagawa-paper") -- Colorscheme
vim.wo.wrap = false

-- Set <space> as the leader key and important keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set({ "n", "x", "v" }, "q", ":bd<CR>", { silent = true })

-- File linker management
vim.opt.autoread = true
vim.opt.swapfile = false

-- LSP
vim.lsp.enable("lua_ls")
vim.lsp.enable("pwsh")
vim.lsp.enable("copilot")
vim.lsp.enable("pyright")

-- LSP Inline Completion
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
			vim.keymap.set(
				"i",
				"<Tab>",
				vim.lsp.inline_completion.get,
				{ desc = "LSP: accept inline completion", buffer = bufnr }
			)
		end
	end,
})

-- Provider
vim.g.python3_host_prog = "C:/Users/M/scoop/shims/python313.exe"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Editor
vim.opt.tabstop = 4 -- How many columns a tab counts for
vim.opt.softtabstop = 4 -- How many spaces a tab feels like in insert mode
vim.opt.shiftwidth = 4 -- How many spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.cindent = true -- Indentation style for C-like languages
vim.opt.number = true -- Show absolute line numbers

-- Blinking cursor
vim.opt.guicursor = {
	"n-v-c:block-blinkwait700-blinkoff400-blinkon250",
	"i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250",
	"r-cr:hor20-blinkwait700-blinkoff400-blinkon250",
	"o:hor50-blinkwait700-blinkoff400-blinkon250",
}

-- Gutter/Sign Column
-- vim.opt.signcolumn = "yes" -- Always show sign column to prevent text shifting
-- vim.opt.numberwidth = 4 -- Width of the number column

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")

-- Highlight matching pairs with a block background so the characters stay readable
vim.api.nvim_set_hl(0, "MatchParen", {
	bg = "#3A3A4B",
	fg = "#fff2cc",
	bold = true,
})

-- Disable LSP semantic highlights
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Disable LSP semantic highlights",
	callback = function(event)
		local id = vim.tbl_get(event, "data", "client_id")
		local client = id and vim.lsp.get_client_by_id(id)
		if client == nil then
			return
		end

		client.server_capabilities.semanticTokensProvider = nil
	end,
})

-- Inline Diagnostics
vim.diagnostic.config({
	underline = false,
	virtual_text = {
		spacing = 1,
		prefix = "●",
	},
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			-- Alas nerdfont icons don't render properly on Medium!
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
})

-- Float Diagnostics
vim.opt.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = true,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "solid",
			scope = "cursor",
			source = "always",
		})
	end,
})
