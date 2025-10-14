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
		local function shorten(path)
			local home = vim.loop.os_homedir()
			return path:gsub("^" .. vim.pesc(home), "~")
		end

		-- Suppress stdout/stderr completely:
		vim.api.nvim_create_user_command("GitPushSilent", function()
			git_async({ "git", "push", "--quiet" }, "Git push complete")
		end, {})

		----------------------------------------------------------------
		-- File events
		----------------------------------------------------------------
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function(args)
				local lines = vim.fn.line("$")
				local bytes = vim.fn.getfsize(args.file)
				notify(string.format('"%s" %dL, %dB written', shorten(args.file), lines, bytes), vim.log.levels.INFO)
			end,
		})

		local notify = require("fidget.notification").notify

		vim.api.nvim_create_user_command("GitCommit", function(args)
			vim.system({ "git", "commit", "-am", args.args }, { text = true }, function(res)
				if res.code == 0 then
					notify("Git commit complete ✓", vim.log.levels.INFO, { title = "Git" })
				else
					notify("Git commit failed", vim.log.levels.ERROR, { title = "Git" })
				end
			end)
		end, { nargs = 1 })

		vim.api.nvim_create_user_command("GitPush", function()
			vim.system({ "git", "push" }, { text = true }, function(res)
				if res.code == 0 then
					notify("Git push complete ✓", vim.log.levels.INFO, { title = "Git" })
				else
					notify("Git push failed", vim.log.levels.ERROR, { title = "Git" })
				end
			end)
		end, {})
	end,
}
