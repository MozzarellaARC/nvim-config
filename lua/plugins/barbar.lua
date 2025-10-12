return {
	"romgrk/barbar.nvim",
	config = function()
		require("lazy").setup({
			{
				dependencies = {
					"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
					"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
				},
				init = function()
					vim.g.barbar_auto_setup = true
				end,
				opts = {
					-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
					-- animation = true,
					-- insert_at_start = true,
					-- …etc.
					-- auto_hide = 1, -- Hide barbar when there are multiple windows (splits)
				},
				-- version = "^1.0.0", -- optional: only update when a new 1.x version is released
			},
		})

		-- Auto-hide barbar when diffview is open
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = { "DiffviewFiles", "DiffviewFileHistory" },
			callback = function()
				pcall(function()
					vim.o.showtabline = 0 -- Hide tabline
				end)
			end,
		})

		-- Restore barbar when leaving diffview
		vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter" }, {
			callback = function()
				vim.schedule(function()
					local ok, ft = pcall(function()
						return vim.bo.filetype
					end)
					if not ok then
						return
					end

					local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory" }
					local is_diffview = vim.tbl_contains(diffview_fts, ft)

					if not is_diffview then
						local has_diffview = false
						for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
							local ok_buf, buf = pcall(vim.api.nvim_win_get_buf, win)
							if ok_buf and vim.api.nvim_buf_is_valid(buf) then
								local ok_ft, bufft = pcall(vim.api.nvim_buf_get_option, buf, "filetype")
								if ok_ft and vim.tbl_contains(diffview_fts, bufft) then
									has_diffview = true
									break
								end
							end
						end
						if not has_diffview then
							vim.o.showtabline = 2 -- Show tabline
						end
					end
				end)
			end,
		})
	end,
}
