return {
	"tpope/vim-fugitive",
	config = function()
		-- Create autocommand to open Fugitive buffers in floating windows
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"fugitive",
				"git",
				"gitcommit",
			},
			callback = function(args)
				local buf = args.buf
				-- Only handle if not already in a floating window
				local wins = vim.fn.win_findbuf(buf)
				for _, win in ipairs(wins) do
					local config = vim.api.nvim_win_get_config(win)
					if config.relative == "" then
						-- It's a normal window, convert to floating
						local width = math.floor(vim.o.columns * 0.8)
						local height = math.floor(vim.o.lines * 0.8)
						local col = math.floor((vim.o.columns - width) / 2)
						local row = math.floor((vim.o.lines - height) / 2 - 1)

						-- Create floating window
						local float_win = vim.api.nvim_open_win(buf, true, {
							relative = "editor",
							width = width,
							height = height,
							col = col,
							row = row,
							style = "minimal",
							border = "solid",
						})
						-- Close the original window if it's not the only one
						if #vim.api.nvim_list_wins() > 1 then
							vim.api.nvim_win_close(win, true)
						end
					end
				end
			end,
		})
	end,
}
