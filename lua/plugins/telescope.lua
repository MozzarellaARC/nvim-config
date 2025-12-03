return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				border = true, -- turn on borders

				-- solid border (using heavy box-drawing chars)
				borderchars = {
					prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
					results = { " ", " ", " ", " ", " ", " ", " ", " " },
					preview = { " ", " ", " ", " ", " ", " ", " ", " " },
				},

				results_title = false,
				prompt_title = false,
				preview_title = false,

				mappings = {
					i = {
						["<C-h>"] = "which_key",
					},
					n = {
						["q"] = "close",
					},
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

		-- vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#3a3a3a" })
		-- vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#3a3a3a" })
		-- vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#3a3a3a" })
		-- vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#3a3a3a" })
	end,
}
