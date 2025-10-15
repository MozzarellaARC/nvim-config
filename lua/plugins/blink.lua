---@module 'blink.cmp'

return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets", "brenoprata10/nvim-highlight-colors" },
	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = "cargo build --release",
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap\
		keymap = {
			preset = "default",
			["<Tab>"] = {
				function(cmp)
					-- Accept ghost text if available
					if cmp.snippet_active() then
						return cmp.accept()
					end
					-- Accept completion if menu is visible and item is selected
					if cmp.is_visible() and cmp.get_selected_item() then
						return cmp.accept()
					end
					-- Otherwise insert tab
					return false
				end,
				"fallback",
			},
			["<CR>"] = {
				function(cmp)
					if cmp.is_visible() and cmp.get_selected_item() then
						return cmp.accept()
					end
					-- Otherwise insert newline
					return false
				end,
				"fallback",
			},
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		term = {
			enabled = true,
			keymap = { preset = "inherit" }, -- Inherits from top level `keymap` config when not set
			sources = {},
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
				},
				-- Inherits from top level config options when not set
				list = {
					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = nil,
						-- When `true`, inserts the completion item automatically when selecting it
						auto_insert = true,
					},
				},
				-- Whether to automatically show the window when new completion items are available
				menu = { auto_show = true },
				-- Displays a preview of the selected item on the current line
				ghost_text = { enabled = true },
			},
		},

		cmdline = {
			enabled = true,
			-- use 'inherit' to inherit mappings from top level `keymap` config
			keymap = {
				preset = "cmdline",
				["<Down>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Tab>"] = { "accept", "fallback" },
			},
			sources = { "buffer", "cmdline" },

			-- OR explicitly configure per cmd type
			-- This ends up being equivalent to above since the sources disable themselves automatically
			-- when not available. You may override their `enabled` functions via
			-- `sources.providers.cmdline.override.enabled = function() return your_logic end`

			-- sources = function()
			--   local type = vim.fn.getcmdtype()
			--   -- Search forward and backward
			--   if type == '/' or type == '?' then return { 'buffer' } end
			--   -- Commands
			--   if type == ':' or type == '@' then return { 'cmdline', 'buffer' } end
			--   return {}
			-- end,

			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
				},
				list = {
					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = true,
						-- When `true`, inserts the completion item automatically when selecting it
						auto_insert = true,
					},
				},
				-- Whether to automatically show the window when new completion items are available
				-- Default is false for cmdline, true for cmdwin (command-line window)
				menu = {
					auto_show = function(ctx, _)
						return ctx.mode == "cmdline"
					end,
				},
				-- Displays a preview of the selected item on the current line
				ghost_text = { enabled = true },
			},
		},

		completion = {
			-- Only show the documentation popup when manually triggered
			documentation = { auto_show = true },
			ghost_text = {
				enabled = true,
				show_with_menu = true,
				show_without_menu = true,
			},
			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 2 },
						{ "source_name" },
						{ "kind_icon" },
					},
					components = {
						-- customize the drawing of kind icons
						kind_icon = {
							text = function(ctx)
								-- default kind icon
								local icon = ctx.kind_icon
								-- if LSP source, check for color derived from documentation
								if ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								-- default highlight group
								local highlight = "BlinkCmpKind" .. ctx.kind
								-- if LSP source, check for color derived from documentation
								if ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr_hl_group then
										highlight = color_item.abbr_hl_group
									end
								end
								return highlight
							end,
						},
					},
				},
			},
		},
		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
	signature = { enabled = true },
}
