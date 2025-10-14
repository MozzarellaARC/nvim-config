return {
	"j-hui/fidget.nvim",
	opts = {
		notification = { override_vim_notify = true },
	},

	config = function(_, opts)
		local fidget = require("fidget")
		fidget.setup(opts)
		local notify = require("fidget.notification").notify
		local function fidget_message(action, file)
			local file_short = vim.fn.fnamemodify(file, ":~")
			local lines = vim.api.nvim_buf_line_count(0)
			local bytes = vim.fn.getfsize(file)
			local msg = string.format('"%s" %dL, %dB %s', file_short, lines, bytes, action)
			notify(msg, vim.log.levels.INFO, { title = "File Event", ttl = 3 })
		end

		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function(args)
				fidget_message("written", args.file)
			end,
		})

		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function(args)
				fidget_message("buffer removed", args.file)
			end,
		})
	end,
}
