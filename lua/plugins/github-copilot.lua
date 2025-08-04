return {
	"github/copilot.vim",
	config = function()
		-- Basic Copilot configuration
		-- vim.g.copilot_no_tab_map = true

		-- Key mappings for Copilot
		-- Accept suggestion with Ctrl+J instead of Tab
		vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
			silent = true,
		})

		-- Panel and navigation mappings
		vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)", { silent = true })
		vim.keymap.set("i", "<C-H>", "<Plug>(copilot-accept-line)", { silent = true })
		vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { silent = true })
		vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { silent = true })
		vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true })
		vim.keymap.set("i", "<M-\\>", "<Plug>(copilot-suggest)", { silent = true })

		-- Panel system key mappings (3-panel layout)
		vim.keymap.set("n", "<leader>cp", function()
			-- Check if panels already exist
			local has_prompt = false
			local has_results = false
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("copilot%-prompt") then
					has_prompt = true
				elseif name:match("copilot%-results") then
					has_results = true
				end
			end

			if has_prompt and has_results then
				vim.notify("Copilot panels already open", vim.log.levels.INFO)
				return
			end

			-- Store the original window info
			local original_win = vim.api.nvim_get_current_win()
			local original_buf = vim.api.nvim_get_current_buf()

			-- Create vertical split to the right and move it to the right side
			vim.cmd("vsplit")
			vim.cmd("wincmd l") -- Move to the right window

			-- Now we're in the right window - create prompt panel first
			vim.cmd("enew")
			vim.cmd("setlocal buftype=nofile")
			vim.cmd("setlocal bufhidden=wipe")
			vim.cmd("setlocal noswapfile")
			vim.cmd("setlocal wrap")
			vim.cmd("file copilot-prompt")

			-- Add prompt instructions
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"=== Copilot Prompt ===",
				"",
				"Type your request below and press <leader>cg to generate:",
				"",
			})

			-- Split this window horizontally to create results panel above
			vim.cmd("split")
			vim.cmd("wincmd k") -- Move to the upper window
			vim.cmd("enew")
			vim.cmd("setlocal buftype=nofile")
			vim.cmd("setlocal bufhidden=wipe")
			vim.cmd("setlocal noswapfile")
			vim.cmd("setlocal wrap")
			vim.cmd("file copilot-results")
			vim.api.nvim_buf_set_lines(0, 0, -1, false, {
				"=== Copilot Results ===",
				"",
				"Generated code and suggestions will appear here.",
				"Use <leader>cg from the prompt panel below to generate.",
				"",
				"Navigation:",
				"- [[ / ]] : Move between suggestions",
				"- <CR>    : Accept current suggestion",
				"- q       : Return to code editor",
			})

			-- Store the results window
			local results_win = vim.api.nvim_get_current_win()

			-- Move back to prompt panel and enter insert mode
			vim.cmd("wincmd j") -- Move to the lower window (prompt)
			vim.api.nvim_win_set_cursor(0, { 4, 0 })
			vim.cmd("startinsert")
		end, {
			silent = true,
			desc = "Open Copilot 3-panel layout",
		})

		-- Generate completions from prompt
		vim.keymap.set("n", "<leader>cg", function()
			local current_buf = vim.api.nvim_get_current_buf()
			local buf_name = vim.api.nvim_buf_get_name(current_buf)

			if buf_name:match("copilot%-prompt") then
				-- Get the prompt from current buffer
				local lines = vim.api.nvim_buf_get_lines(current_buf, 3, -1, false)
				local prompt = table.concat(lines, "\n"):gsub("^%s*", ""):gsub("%s*$", "")

				if prompt ~= "" then
					-- Store the results window info first
					local results_win = nil
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)
						if name:match("copilot%-results") then
							results_win = win
							break
						end
					end

					-- Go to original code window (far left)
					vim.cmd("wincmd h")

					-- Add prompt as comment for context
					local original_line = vim.api.nvim_win_get_cursor(0)[1]
					vim.api.nvim_buf_set_lines(0, original_line, original_line, false, { "// " .. prompt })
					vim.api.nvim_win_set_cursor(0, { original_line + 1, 0 })

					-- Open copilot panel
					vim.cmd("Copilot panel")

					-- Move the copilot panel to replace the results window
					vim.defer_fn(function()
						-- Find the copilot panel window
						local copilot_win = nil
						local copilot_buf = nil
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							local name = vim.api.nvim_buf_get_name(buf)
							if name:match("^copilot://") then
								copilot_win = win
								copilot_buf = buf
								break
							end
						end

						if copilot_win and results_win then
							-- Move to the results window and replace its buffer with copilot buffer
							vim.api.nvim_win_set_buf(results_win, copilot_buf)

							-- Close the original copilot window if it's different from results window
							if copilot_win ~= results_win then
								pcall(vim.api.nvim_win_close, copilot_win, false)
							end

							-- Set up keymaps for the copilot panel in the results window
							vim.api.nvim_set_current_win(results_win)

							-- Set up panel-specific key mappings for this buffer
							vim.keymap.set("n", "<CR>", function()
								-- Accept the current suggestion
								vim.cmd("normal! ")
							end, { buffer = copilot_buf, silent = true, desc = "Accept suggestion" })

							vim.keymap.set("n", "[[", "[[", { buffer = copilot_buf, silent = true })
							vim.keymap.set("n", "]]", "]]", { buffer = copilot_buf, silent = true })
							vim.keymap.set("n", "q", function()
								-- Go back to code window instead of closing
								vim.cmd("wincmd h")
							end, { buffer = copilot_buf, silent = true })
						end

						-- Clean up the prompt comment
						vim.cmd("wincmd h")
						vim.api.nvim_buf_set_lines(0, original_line, original_line + 1, false, {})
					end, 500)
				else
					vim.notify("Please enter a prompt first", vim.log.levels.WARN)
				end
			else
				vim.notify("Please use this command from the prompt panel", vim.log.levels.WARN)
			end
		end, {
			silent = true,
			desc = "Generate code from prompt",
		})

		-- Close Copilot panels
		vim.keymap.set("n", "<leader>cc", function()
			local panels_closed = 0
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				local name = vim.api.nvim_buf_get_name(buf)
				if name:match("copilot%-prompt") or name:match("copilot%-results") or name:match("^copilot://") then
					pcall(vim.api.nvim_win_close, win, false)
					panels_closed = panels_closed + 1
				end
			end
			if panels_closed > 0 then
				vim.notify("Closed " .. panels_closed .. " Copilot panel(s)", vim.log.levels.INFO)
			else
				vim.notify("No Copilot panels to close", vim.log.levels.INFO)
			end
		end, {
			silent = true,
			desc = "Close all Copilot panels",
		})
		vim.keymap.set("n", "<leader>cs", ":Copilot status<CR>", {
			silent = true,
			desc = "Check Copilot status",
		})
		vim.keymap.set("n", "<leader>ce", ":Copilot enable<CR>", {
			silent = true,
			desc = "Enable Copilot",
		})
		vim.keymap.set("n", "<leader>cd", ":Copilot disable<CR>", {
			silent = true,
			desc = "Disable Copilot",
		})

		-- File type configuration (optional - customize as needed)
		vim.g.copilot_filetypes = {
			["*"] = true,
			xml = false,
			markdown = true,
		}

		-- Syntax highlighting for Copilot suggestions
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "CopilotSuggestion", {
					fg = "#555555",
					ctermfg = 8,
					italic = true,
					force = true,
				})
			end,
		})

		-- Auto commands for better panel experience
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot://*",
			callback = function()
				-- Set up panel-specific key mappings
				vim.keymap.set("n", "<CR>", function()
					-- Try to accept the suggestion and return to code window
					vim.cmd("normal! ")
					-- Move back to code window (leftmost)
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)
						if not name:match("copilot") then
							vim.api.nvim_set_current_win(win)
							break
						end
					end
				end, { buffer = true, silent = true, desc = "Accept suggestion and return to code" })

				vim.keymap.set("n", "[[", "[[", { buffer = true, silent = true, desc = "Previous suggestion" })
				vim.keymap.set("n", "]]", "]]", { buffer = true, silent = true, desc = "Next suggestion" })
				vim.keymap.set("n", "q", function()
					-- Return to code window instead of closing
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local name = vim.api.nvim_buf_get_name(buf)
						if not name:match("copilot") then
							vim.api.nvim_set_current_win(win)
							break
						end
					end
				end, { buffer = true, silent = true, desc = "Return to code window" })
			end,
		})

		-- Function to toggle Copilot panel (modified for vertical split)
		local function toggle_copilot_panel()
			local copilot_buffers =
				vim.fn.filter(vim.fn.range(1, vim.fn.bufnr("$")), 'bufexists(v:val) && bufname(v:val) =~ "^copilot://"')

			if #copilot_buffers > 0 then
				-- Close existing copilot panels
				for _, buf in ipairs(copilot_buffers) do
					local windows = vim.fn.win_findbuf(buf)
					for _, win in ipairs(windows) do
						vim.api.nvim_win_close(win, false)
					end
				end
			else
				-- Open copilot panel and move to vertical split
				vim.cmd("Copilot panel")
				vim.cmd("wincmd L")
			end
		end

		-- Add toggle mapping
		vim.keymap.set("n", "<leader>ct", toggle_copilot_panel, {
			silent = true,
			desc = "Toggle Copilot panel",
		})

		-- Create user commands for easier access (modified for vertical split)
		vim.api.nvim_create_user_command("CopilotPanel", function()
			vim.cmd("Copilot panel")
			vim.cmd("wincmd L")
		end, {})
		vim.api.nvim_create_user_command("CopilotToggle", toggle_copilot_panel, {})

		-- Setup notification for first time users
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				-- Check if Copilot is set up
				vim.defer_fn(function()
					local status = vim.fn.system("copilot status")
					if status:match("not authenticated") or status:match("disabled") then
						vim.notify("Run :Copilot setup to authenticate GitHub Copilot", vim.log.levels.INFO)
					end
				end, 1000)
			end,
		})
	end,
}

