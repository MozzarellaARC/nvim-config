vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
})

-- text below applies for Neovide only
if vim.g.neovide then
	vim.o.guifont = "Monaspace Krypton Var:b"
end

vim.opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
vim.cmd.colorscheme("kanagawa-paper") -- Colorscheme
vim.wo.wrap = false -- Text wrapping

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

-- Set up diagnostic highlight groups with underlines
vim.cmd([[
	highlight DiagnosticUnderlineError cterm=underline gui=underline guisp=Red
	highlight DiagnosticUnderlineWarn cterm=underline gui=underline guisp=Orange
	highlight DiagnosticUnderlineInfo cterm=underline gui=underline guisp=LightBlue
	highlight DiagnosticUnderlineHint cterm=underline gui=underline guisp=LightGray
]])

-- Float Diagnostics
vim.opt.updatetime = 250
-- Manual keymap to open diagnostics (use <leader>d or customize)
vim.keymap.set("n", "<LeftRelease>", function()
	vim.diagnostic.open_float(nil, {
		focusable = true,
		close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
		border = "none",
		scope = "cursor",
		source = "always",
	})
end, { desc = "Show diagnostics" })

-- Floating Window
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "fugitive", "git", "gitcommit", "conform", "ConformInfo" },
	callback = function(args)
		local buf = args.buf

		-- Avoid converting already floating windows
		local wins = vim.fn.win_findbuf(buf)
		for _, win in ipairs(wins) do
			local config = vim.api.nvim_win_get_config(win)
			if config.relative == "" then
				local width = math.floor(vim.o.columns * 0.8)
				local height = (math.floor(vim.o.lines * 0.8) - 2)
				local col = math.floor((vim.o.columns - width) / 2 - 1)
				local row = math.floor((vim.o.lines - height) / 2 - 1)
				local float_win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					width = width,
					height = height,
					col = col,
					row = row,
					border = "solid",
				})

				-- Close the original non-floating window
				if #vim.api.nvim_list_wins() > 1 then
					vim.api.nvim_win_close(win, true)
				end

				-- Auto-close when leaving the buffer or focusing another one
				vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave", "WinEnter" }, {
					buffer = buf,
					once = false,
					callback = function()
						if vim.api.nvim_win_is_valid(float_win) then
							vim.api.nvim_win_close(float_win, true)
						end
					end,
				})

				-- Auto-close if a new buffer is opened in the same window
				vim.api.nvim_create_autocmd("BufEnter", {
					callback = function()
						if vim.api.nvim_win_is_valid(float_win) and vim.api.nvim_get_current_win() ~= float_win then
							vim.api.nvim_win_close(float_win, true)
						end
					end,
				})
			end
		end
	end,
})
