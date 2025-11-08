return {
	"leath-dub/snipe.nvim",
	config = function()
		local snipe = require("snipe")

		snipe.setup({
			hints = {
				-- Use numbers instead of letters for marks
				dictionary = "1234567890abcefgijklmnoprstuwxyz",
			},
			ui = {
				-- Where to place the ui window
				-- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
				---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
				position = "center",
				-- Override options passed to `nvim_open_win`
				-- Be careful with this as snipe will not validate
				-- anything you override here. See `:h nvim_open_win`
				-- for config options
				---@type vim.api.keyset.win_config
				open_win_override = {
					title = "Snipe",
					border = "solid", -- use "rounded" for rounded border
				},
			},
			navigate = {
				-- Specifies the "leader" key
				-- This allows you to select a buffer but defer the action.
				-- NOTE: this does not override your actual leader key!
				-- leader = ",",

				-- Leader map defines keys that follow a selection prefixed by the
				-- leader key. For example (with tag "a"):
				-- ,ad -> run leader_map["d"](m, i)
				-- NOTE: the leader_map cannot specify multi character bindings.
				leader_map = {
					["d"] = function(m, i)
						require("snipe").close_buf(m, i)
					end,
					["v"] = function(m, i)
						require("snipe").open_vsplit(m, i)
					end,
					["h"] = function(m, i)
						require("snipe").open_split(m, i)
					end,
				},

				-- When the list is too long it is split into pages
				-- `[next|prev]_page` options allow you to navigate
				-- this list
				next_page = "J",
				prev_page = "K",

				-- You can also just use normal navigation to go to the item you want
				-- this option just sets the keybind for selecting the item under the
				-- cursor
				---@type string|string[]
				under_cursor = "<cr>",

				-- In case you changed your mind, provide a keybind that lets you
				-- cancel the snipe and close the window.
				---@type string|string[]
				cancel_snipe = "<esc>",

				-- Close the buffer under the cursor
				-- Remove "j" and "k" from your dictionary to navigate easier to delete
				-- NOTE: Make sure you don't use the character below on your dictionary
				close_buffer = "d",

				-- Open buffer in vertical split
				open_vsplit = "V",

				-- Open buffer in split, based on `vim.opt.splitbelow`
				open_split = "H",

				-- Change tag manually (note only works if `persist_tags` is not enabled)
				-- change_tag = "C",
			},
		})

		vim.keymap.set("n", "<leader>`", snipe.open_buffer_menu)
	end,
}
