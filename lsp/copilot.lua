vim.lsp.config("copilot", {
	root_markers = { ".git" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
			vim.keymap.set("i", "<Tab>", function()
				vim.lsp.inline_completion.get()
			end, { desc = "LSP: accept inline completion", buffer = bufnr })
		end
	end,
})
