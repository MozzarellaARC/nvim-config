vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable("luals", "clangd", "pyright")

-- Package Manager
require("config.lazy")

-- Key Remap
require("config.keymap")
