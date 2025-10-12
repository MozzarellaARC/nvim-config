vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
})

-- Package Manager
require("config.lazy")
-- Key Remap
require("config.keymap")
vim.cmd.colorscheme("kanagawa-paper-ink")
