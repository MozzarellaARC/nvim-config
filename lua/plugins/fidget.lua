return {
	"j-hui/fidget.nvim",
	opts = {
		notification = {
			override_vim_notify = false,
		},
	},
	config = function(_, opts)
		require("fidget").setup(opts)
		local notify = require("fidget.notification").notify

		-- shorten path (replace home with ~)
		local function shorten(path)
			local home = vim.loop.os_homedir()
			return path:gsub("^" .. vim.pesc(home), "~")
		end

		----------------------------------------------------------------
		-- File events
		----------------------------------------------------------------
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function(args)
				local lines = vim.fn.line("$")
				local bytes = vim.fn.getfsize(args.file)
				vim.schedule(function()
					notify(
						string.format('"%s" %dL, %dB written', shorten(args.file), lines, bytes),
						vim.log.levels.INFO
					)
				end)
			end,
		})

		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function(args)
				local file = args.file or "[No Name]"
				vim.defer_fn(function()
					require("fidget.notification").notify(
						string.format('"%s" buffer removed', file),
						vim.log.levels.WARN
					)
				end, 10) -- 10 ms delay
			end,
		})

		----------------------------------------------------------------
		-- Git commands
		----------------------------------------------------------------
		vim.api.nvim_create_user_command("GitCommit", function(args)
			vim.system({ "git", "commit", "-am", args.args }, { text = true }, function(res)
				vim.schedule(function()
					if res.code == 0 then
						notify("Git commit complete ✓", vim.log.levels.INFO, { title = "Git" })
					else
						notify("Git commit failed:\n" .. res.stderr, vim.log.levels.ERROR, { title = "Git" })
					end
				end)
			end)
		end, { nargs = 1 })

		vim.api.nvim_create_user_command("GitPush", function()
			vim.system({ "git", "push" }, { text = true }, function(res)
				vim.schedule(function()
					if res.code == 0 then
						notify("Git push complete ✓", vim.log.levels.INFO, { title = "Git" })
					else
						notify("Git push failed:\n" .. res.stderr, vim.log.levels.ERROR, { title = "Git" })
					end
				end)
			end)
		end, {})
	end,
}
