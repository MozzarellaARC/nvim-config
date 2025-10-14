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

		----------------------------------------------------------------
		-- Git helpers
		----------------------------------------------------------------
		local function git_async(cmd, msg)
			vim.system(cmd, { text = true }, function(res)
				if res.code == 0 then
					notify(msg .. " ✓", vim.log.levels.INFO, { title = "Git" })
				else
					notify("Git error:\n" .. res.stderr, vim.log.levels.ERROR, { title = "Git" })
				end
			end)
		end

		-- Commands for async git commit / push
		vim.api.nvim_create_user_command("GitCommit", function(args)
			git_async({ "git", "commit", "-m", args.args }, "Git commit complete")
		end, { nargs = 1, desc = "Run git commit asynchronously" })

		vim.api.nvim_create_user_command("GitPush", function()
			git_async({ "git", "push" }, "Git push complete")
		end, { desc = "Run git push asynchronously" })
	end,
}
