vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	-- { src = "https://github.com/EdenEast/nightfox.nvim" },
	-- { src = "https://github.com/slugbyte/lackluster.nvim" },
	{ src = "https://github.com/github/copilot.vim" },
	-- { src = "https://github.com/ishan9299/nvim-solarized-lua" },
})

-- Neovide specifics
if vim.g.neovide then
	vim.o.guifont = "JetbrainsMono Nerd Font Mono"
elseif vim.g.nvimqt then
	vim.o.guifont = "JetbrainsMono Nerd Font Mono"
end
vim.keymap.set({ "n", "v", "i" }, "<MiddleMouse>", "<Nop>", { noremap = true, silent = true })
vim.opt.mouse = "a"

vim.o.shell = "powershell -noe -NoLogo"

-- Mouse auto focus_window_under_mouse
local function focus_window_under_mouse()
	vim.schedule(function()
		local mouse_pos = vim.fn.getmousepos()
		local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
		if mouse_pos.winid ~= 0 and buf_name ~= "DiffView" then
			vim.api.nvim_set_current_win(mouse_pos.winid)
		end
	end)
end

for _, event in ipairs({ "<ScrollWheelUp>", "<ScrollWheelDown>" }) do
	vim.keymap.set("", event, function()
		focus_window_under_mouse()
		return event
	end, { expr = true, noremap = true, silent = true })
end

-- Disable netrw
vim.g.loaded_netrw = 0
vim.g.loaded_netrwPlugin = 0

-- File linker management
vim.opt.autoread = true
vim.opt.swapfile = false

-- General keymap settings
vim.g.mapleader = " " -- Leadner key <space>
vim.g.maplocalleader = "//" -- Local leader key <backslash>
vim.opt.clipboard = "unnamedplus" -- Clipboard
vim.keymap.set("n", "<Esc>", function() -- Clear search on <Esc>
	vim.fn.setreg("/", "")
	vim.cmd("nohlsearch")
end)

-- Editor
vim.wo.wrap = true -- Text wrapping
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cindent = true -- Indentation style for C-like languages
vim.opt.smartindent = true -- Insert indents automatically

-- Theme
vim.opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
vim.cmd.colorscheme("kanagawa-paper") -- Colorscheme
-- vim.cmd.colorscheme("solarized") -- Colorscheme
-- vim.o.background = "light"
-- vim.cmd.colorscheme("dayfox") -- Colorscheme
-- vim.cmd.colorscheme("lackluster") -- Colorscheme
vim.opt.winborder = "none"

vim.opt.fillchars:append("diff:╱")
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#491e24", bold = true })

-- Highlight matching pairs with a block background so the characters stay readable
vim.api.nvim_set_hl(0, "MatchParen", {
	bg = "#3A3A4B",
	fg = "#fff2cc",
	bold = true,
})

-- Blinking cursor
vim.opt.guicursor = {
	"n-v-c:block-blinkwait700-blinkoff400-blinkon250",
	"i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250",
	"r-cr:hor20-blinkwait700-blinkoff400-blinkon250",
	"o:hor50-blinkwait700-blinkoff400-blinkon250",
}

-- Provider
vim.g.python3_host_prog = "C:/Users/M/scoop/apps/python313/current/python.exe"

-- LSP enabler
vim.lsp.enable({ "lua_ls" })
vim.lsp.enable("pwsh")
vim.lsp.enable("ruff")
vim.lsp.enable("basedpyright")
vim.lsp.enable("rust_analyzer")
-- vim.lsp.enable("pyright")

-- vim.lsp.enable("copilot")

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")

-- LSP Inline Completion
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
			vim.keymap.set("i", "<Tab>", function()
				if not vim.lsp.inline_completion.get() then
					return "<Tab>"
				end
			end, { expr = true, desc = "Accept the current inline completion" })
		end
	end,
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

-- Diagnostics integration
vim.diagnostic.config({
	-- virtual_text = {
	-- 	enabled = true,
	-- },
	signs = false,
	underline = {
		enabled = true,
	},
})

-- Float Diagnostics
vim.opt.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = true,
			border = "none",
			scope = "cursor",
			source = "always",
			max_height = 10,
			max_width = 80,
			close_events = { "CursorMoved", "InsertEnter", "WinScrolled" },
		})
	end,
})

-- Suppress specific error messages
local original_echo = vim.api.nvim_echo
vim.api.nvim_echo = function(chunks, history, opts)
	local msg = table.concat(vim.tbl_map(function(c)
		return c[1]
	end, chunks))
	if msg:match("Couldn't find buffer") or msg:match("written") then
		return
	end
	return original_echo(chunks, history, opts)
end

-- General Floating Window
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
