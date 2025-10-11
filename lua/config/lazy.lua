-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Provider
vim.g.python3_host_prog = "C:/Python313/python.exe"

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

-- Cache optimization
vim.o.swapfile = false
vim.opt.autoread = true

-- Clipboard

vim.opt.clipboard = "unnamedplus"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- Add your plugins here, or import them from other modules
		{ import = "plugins" },
		-- You can also import plugins from a specific file
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- automatically check for plugin updates (notifications disabled to prevent intrusive prompts)
	checker = {
		enabled = true,
		-- concurrency = 1, ---@type number? set to 1 to check for updates very slowly
		notify = false, -- Disable notifications that pause your buffer
		-- frequency = 3600, -- Check only once per hour instead of constantly
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		-- enabled = true,
		notify = false, -- Disable notifications for config changes (this was the main culprit!)
	},
	performance = {
		cache = {
			enabled = true,
		},
	},
})
