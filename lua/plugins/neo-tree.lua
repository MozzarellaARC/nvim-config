return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		opts = {
			filesystem = {
				window = {
					mappings = {
						["<cr>"] = "open",
						["<LeftRelease>"] = "open",
					},
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(file_path)
						-- Set buffer as temporary (will be deleted when hidden)
						vim.schedule(function()
							local bufnr = vim.fn.bufnr(file_path)
							if bufnr ~= -1 then
								vim.bo[bufnr].bufhidden = "delete"
								
								-- Create autocommand to make buffer permanent on insert mode
								local augroup = vim.api.nvim_create_augroup("NeoTreeTempBuffer_" .. bufnr, { clear = true })
								vim.api.nvim_create_autocmd("InsertEnter", {
									group = augroup,
									buffer = bufnr,
									once = true,
									callback = function()
										vim.bo[bufnr].bufhidden = ""
										vim.api.nvim_del_augroup_by_id(augroup)
									end,
								})
							end
						end)
					end,
				},
			},
		},
	},
}
