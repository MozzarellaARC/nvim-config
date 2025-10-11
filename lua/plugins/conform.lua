return {
	enable = false,
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			zig = { "zigfmt" },
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			vue = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			less = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			graphql = { "prettierd", "prettier", stop_after_first = true },
			handlebars = { "prettier" },
			go = { "goimports", "gofmt" },
			rust = { "rustfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			java = { "google-java-format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			fish = { "fish_indent" },
			xml = { "xmlformat" },
			sql = { "sql_formatter" },
			-- Use the "*" filetype to run formatters on all filetypes.
			-- ["*"] = { "codespell" },
			-- Use the "_" filetype to run formatters on filetypes that don't
			-- have other formatters configured.
			-- ["_"] = { "trim_whitespace" },
		},
		-- Set up format-on-save
		-- format_on_save = {
		-- 	-- These options will be passed to conform.format()
		-- 	timeout_ms = 500,
		-- 	lsp_fallback = true,
		-- },
		-- Set up format after save for async formatting
		format_after_save = {
			lsp_fallback = true,
		},
		-- Customize formatters
		-- formatters = {
		-- 	shfmt = {
		-- 		prepend_args = { "-i", "2" },
		-- 	},
		-- 	-- # Example of using dprint only when a dprint.json file is present
		-- 	-- dprint = {
		-- 	--   condition = function(ctx)
		-- 	--     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
		-- 	--   end,
		-- 	-- },
		-- 	--
		-- 	-- # Example of using shfmt with extra args
		-- 	-- shfmt = {
		-- 	--   prepend_args = { "-i", "2", "-ci" },
		-- 	-- },
		-- },
	},
	-- init = function()
	-- 	-- If you want the formatexpr, here is the place to set it
	-- 	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	-- end,
}
