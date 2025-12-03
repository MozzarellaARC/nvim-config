-- ============================================================================
-- RESESSION.NVIM - SESSION MANAGER CONFIGURATION
-- ============================================================================
--
-- This plugin provides powerful session management for Neovim, allowing you to:
-- - Save and restore your entire workspace (buffers, windows, tabs, etc.)
-- - Automatically save sessions on exit and restore on startup
-- - Manually manage multiple named sessions
-- - Integrate with barbar.nvim for proper tab restoration
--
-- IMPORTANT NOTES:
-- - Resession uses 'session' (singular) directory by default, NOT 'sessions'
-- - Sessions are stored as JSON files in: ~/.local/share/nvim-data/session/
-- - The 'globals' sessionoption is required for barbar integration
-- - SessionSavePre event must be fired before saving for barbar compatibility
--
-- KEYBINDINGS:
-- <leader>sw - Save session with timestamp (manual_YYYYMMDD_HHMMSS)
-- <leader>ss - Load the last saved session
-- <leader>sl - List all available sessions
-- <leader>sd - Delete a session (with input prompt)
--
-- ============================================================================

return {
	"stevearc/resession.nvim",
	config = function()
		local resession = require("resession")

		-- ========================================================================
		-- PLUGIN SETUP
		-- ========================================================================
		-- Let resession use its default directory to avoid path conflicts.
		-- DO NOT manually specify a directory - resession handles this internally
		-- and will cause path duplication errors if you override it.
		resession.setup({
			autosave = {
				enabled = false, -- Disable autosave to prevent conflicts with manual saves
				interval = 60, -- How often to autosave (if enabled)
				notify = false, -- Don't show notifications for autosaves
			},
		})

		-- ========================================================================
		-- BARBAR INTEGRATION SETUP
		-- ========================================================================
		-- Add 'globals' to sessionoptions so that barbar can save/restore its state.
		-- This is CRITICAL for barbar to work properly with sessions.
		-- Without this, barbar won't remember tab order, pinned tabs, etc.
		vim.opt.sessionoptions:append("globals")

		-- ========================================================================
		-- AUTO-SAVE ON EXIT
		-- ========================================================================
		-- Automatically save the current session when Neovim is about to exit.
		-- This ensures you never lose your workspace setup.
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				-- IMPORTANT: Fire the SessionSavePre event BEFORE saving.
				-- This allows barbar to prepare its state for saving.
				-- Without this, barbar's tab configuration won't be preserved.
				vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })

				-- Save the current session as 'last' for auto-restore on next startup.
				-- Using pcall to prevent errors from crashing Neovim during exit.
				pcall(resession.save, "last", { notify = false })
			end,
		})

		-- ========================================================================
		-- AUTO-LOAD ON STARTUP
		-- ========================================================================
		-- Automatically restore the last session when starting Neovim without arguments.
		-- This creates a seamless workflow where your workspace is always restored.
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				-- Add a small delay to ensure all plugins are fully loaded before
				-- attempting to restore the session. This prevents race conditions
				-- where session restoration happens before plugins are ready.
				vim.defer_fn(function()
					-- Only auto-load if Neovim was started without file arguments.
					-- If you opened specific files, we don't want to override them.
					if vim.fn.argc() == 0 then
						-- Use pcall and silence_errors to prevent startup crashes
						-- if the session file is corrupted or missing.
						pcall(resession.load, "last", { silence_errors = true })
					end
				end, 100) -- 100ms delay should be sufficient for plugin loading
			end,
		})

		-- ========================================================================
		-- MANUAL SESSION SAVE (<leader>sw)
		-- ========================================================================
		-- Save a timestamped session manually. This is useful for creating
		-- checkpoint saves before major changes or experiments.
		--     vim.keymap.set("n", "<leader>sw", function()
		--       -- Fire SessionSavePre event for barbar compatibility
		--       vim.api.nvim_exec_autocmds('User', {pattern = 'SessionSavePre'})
		--
		--       -- Create a unique session name with timestamp
		--       -- Format: manual_YYYYMMDD_HHMMSS (e.g., manual_20250730_143022)
		--       local session_name = "manual_" .. os.date("%Y%m%d_%H%M%S")
		--       print("Saving session: " .. session_name)
		--
		-- --      -- Use pcall to catch and display any errors gracefully
		--       local ok, err = pcall(resession.save, session_name)
		--       if not ok then
		--         print("Error saving session: " .. tostring(err))
		--       else
		--         print("Session saved successfully!")
		--       end
		--     end, { desc = "Save session manually with timestamp" })

		-- ========================================================================
		-- LOAD LAST SESSION (<leader>ss)
		-- ========================================================================
		-- Manually load the last saved session. Useful for switching back to
		-- your main workspace after working on something else.
		--     vim.keymap.set("n", "<leader>ss", function()
		--       print("Loading last session...")
		--
		-- --      -- Use pcall to handle errors gracefully
		--       local ok, err = pcall(resession.load, "last", { silence_errors = true })
		--       if not ok then
		--         print("Error loading session: " .. tostring(err))
		--       else
		--         print("Session loaded successfully!")
		--       end
		--     end, { desc = "Load the last saved session" })

		-- ========================================================================
		-- LIST SESSIONS (<leader>sl)
		-- ========================================================================
		-- Display all available sessions. Helpful for managing multiple workspaces.
		--     vim.keymap.set("n", "<leader>sl", function()
		--       print("Available sessions:")
		--
		--       -- IMPORTANT: Use 'session' (singular) not 'sessions' (plural)!
		--       -- This is resession's actual default directory structure.
		--       local sessions_dir = vim.fn.stdpath('data') .. '/session'
		--
		--       -- Find all .json files in the session directory
		--       local files = vim.fn.glob(sessions_dir .. '/*.json', false, true)
		--
		--       if #files == 0 then
		--         print("  No sessions found")
		--       else
		-- --        -- Extract just the filename without extension for display
		--         for _, file in ipairs(files) do
		--           local name = vim.fn.fnamemodify(file, ':t:r') -- :t = tail, :r = remove extension
		--           print("  " .. name)
		--         end
		--       end
		--     end, { desc = "List all available sessions" })

		-- ========================================================================
		-- DELETE SESSION (<leader>sd)
		-- ========================================================================
		-- Delete a session with user confirmation. Helps clean up old sessions.
		--     vim.keymap.set("n", "<leader>sd", function()
		--       -- Use vim.ui.input for a clean input prompt
		--       vim.ui.input({ prompt = "Delete session: " }, function(name)
		--         if name and name ~= "" then
		--           -- Use pcall to handle errors (e.g., session doesn't exist)
		--           local ok, err = pcall(resession.delete, name)
		--           if not ok then
		--             print("Error deleting session: " .. tostring(err))
		--           else
		--             print("Session deleted: " .. name)
		--           end
		--         end
		--       end)
		--     end, { desc = "Delete a session (with confirmation)" })
	end,
}

-- ============================================================================
-- TROUBLESHOOTING GUIDE
-- ============================================================================
--
-- PROBLEM: Sessions not saving/loading
-- SOLUTION: Check that ~/.local/share/nvim-data/session/ directory exists
--
-- PROBLEM: Barbar tabs not restored properly
-- SOLUTION: Ensure 'globals' is in sessionoptions and SessionSavePre fires
--
-- PROBLEM: Path duplication errors (ENOENT)
-- SOLUTION: Don't specify custom directory, let resession use defaults
--
-- PROBLEM: Session restoration crashes on startup
-- SOLUTION: Increase the defer_fn delay or check for plugin conflicts
--
-- PROBLEM: Auto-load interfering with file arguments
-- SOLUTION: The argc() check prevents this, but verify the condition
--
-- ============================================================================
-- WORKFLOW TIPS
-- ============================================================================
--
-- 1. DAILY WORKFLOW:
--    - Start Neovim normally (auto-loads last session)
--    - Work on your project
--    - Exit Neovim (auto-saves as 'last')
--
-- 2. EXPERIMENT WORKFLOW:
--    - Press <leader>sw before trying risky changes
--    - Experiment freely
--    - If things break, press <leader>ss to restore
--
-- 3. MULTIPLE PROJECTS:
--    - Use <leader>sw to save project-specific sessions
--    - Use <leader>sl to see all your saved sessions
--    - Load specific sessions with :lua resession.load("session_name")
--
-- 4. CLEANUP:
--    - Use <leader>sl to see all sessions
--    - Use <leader>sd to delete old/unused sessions
--
-- ============================================================================
