vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

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

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")

-- Highlight matching pairs with a block background so the characters stay readable
local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "MatchParen", {
	bg = "#D7D6CE",
	fg = visual_hl.bg,
	bold = true,
})
