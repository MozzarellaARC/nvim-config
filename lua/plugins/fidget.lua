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

		--------------------------------------------------------------------
		-- 🧠 Git notifications
		--------------------------------------------------------------------

		-- Detect Git commit via Fugitive
		vim.api.nvim_create_autocmd("User", {
			pattern = "FugitiveCommit",
			callback = function()
				notify("Git commit created", vim.log.levels.INFO, { title = "Git" })
			end,
		})

		-- Detect Git push via Fugitive
		vim.api.nvim_create_autocmd("User", {
			pattern = "FugitivePush",
			callback = function()
				notify("Git push completed", vim.log.levels.INFO, { title = "Git" })
			end,
		})

		-- Detect git commit/push in shell or terminal commands
		vim.api.nvim_create_autocmd("TermClose", {
			callback = function(args)
				local chan = vim.api.nvim_buf_get_var(args.buf, "term_title")
				if not chan then
					return
				end
				if chan:match("git commit") then
					notify("Git commit executed", vim.log.levels.INFO, { title = "Git" })
				elseif chan:match("git push") then
					notify("Git push executed", vim.log.levels.INFO, { title = "Git" })
				end
			end,
		})
	end,
}
