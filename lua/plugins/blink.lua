return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = { "rafamadriz/friendly-snippets" },

	-- use a release tag to download pre-built binaries
	-- version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	build = "cargo build --release",
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
		-- See :h blink-cmp-config-keymap for defining your own keymap
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
					if cmp.is_visible() and cmp.get_selected_item() and vim.api.nvim_get_mode().mode ~= "c" then
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

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			-- Controls how the completion items are rendered on the popup window
			menu = {
				draw = {
					-- Aligns the keyword you've typed to a component in the menu
					align_to = "label", -- or 'none' to disable, or 'cursor' to align to the cursor
					-- Left and right padding, optionally { left, right } for different padding on each side
					padding = 1,
					-- Gap between columns
					gap = 1,
					-- Priority of the cursorline highlight, setting this to 0 will render it below other highlights
					cursorline_priority = 10000,
					-- Appends an indicator to snippets label
					snippet_indicator = "~",
					-- Use treesitter to highlight the label text for the given list of sources
					treesitter = {},
					-- treesitter = { 'lsp' }

					-- Components to render, grouped by column
					columns = { { "label", "source_name", gap = 1 }, { "kind_icon" } },

					-- Definitions for possible components to render. Each defines:
					--   ellipsis: whether to add an ellipsis when truncating the text
					--   width: control the min, max and fill behavior of the component
					--   text function: will be called for each item
					--   highlight function: will be called only when the line appears on screen
					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								return ctx.kind_icon .. ctx.icon_gap
							end,
							-- Set the highlight priority to 20000 to beat the cursorline's default priority of 10000
							highlight = function(ctx)
								return { { group = ctx.kind_hl, priority = 20000 } }
							end,
						},

						kind = {
							ellipsis = false,
							width = { fill = true },
							text = function(ctx)
								return ctx.kind
							end,
							highlight = function(ctx)
								return ctx.kind_hl
							end,
						},

						label = {
							width = { fill = true, max = 60, min = 40 },
							text = function(ctx)
								return ctx.label .. ctx.label_detail
							end,
							highlight = function(ctx)
								-- label and label details
								local highlights = {
									{
										0,
										#ctx.label,
										group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
									},
								}
								if ctx.label_detail then
									table.insert(
										highlights,
										{ #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
									)
								end

								-- characters matched on the label by the fuzzy matcher
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end

								return highlights
							end,
						},

						label_description = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},

						source_name = {
							ellipsis = false,
							width = { max = 4 },
							text = function(ctx)
								-- Make uppercase and truncate safely to 4 characters
								return string.upper(ctx.source_name:sub(1, 4))
							end,
							highlight = "BlinkCmpSource",
						},

						source_id = {
							width = { max = 30 },
							text = function(ctx)
								return ctx.source_id
							end,
							highlight = "BlinkCmpSource",
						},
					},
				},
			},

			documentation = {
				auto_show = true,
			},
			ghost_text = { enabled = true },
			list = { selection = {
				preselect = true,
				auto_insert = false,
			} },
			accept = { auto_brackets = {
				enabled = true,
			} },
		},

		cmdline = {
			enabled = true,
			keymap = { preset = "inherit" }, -- Inherits from top level `keymap` config when not set
			sources = { "buffer", "cmdline" },
			completion = {
				menu = { auto_show = true },
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
					show_on_backspace = true,
				},
				ghost_text = {
					enabled = true,
				},
			},
		},

		term = {
			enabled = true,
			keymap = { preset = "inherit" }, -- Inherits from top level `keymap` config when not set

			completion = {
				menu = { auto_show = true },
				ghost_text = { enabled = true },
			},
		},

		-- test

		signature = {
			enabled = true,
			trigger = { enabled = true },
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
}
