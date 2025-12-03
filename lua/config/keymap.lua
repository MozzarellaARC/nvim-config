local map = vim.keymap.set

-- Disable default keybindings
map({ "n", "i", "v" }, "<C-r>", "<Nop>")
map({ "n", "v" }, "h", "<Nop>")
map({ "n", "v" }, "j", "<Nop>")
map({ "n", "v" }, "k", "<Nop>")
map({ "n", "v" }, "l", "<Nop>")
map({ "n", "v" }, "Q", "<Nop>")

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

---General keybindings
map("n", "z", "u") -- undo with z
map("n", "<C-S-z>", "<C-r>") -- Redo with Shift+z

map("n", "<C-s>", ":w<CR>") -- Save with Ctrl+s
map("i", "<C-s>", "<Esc>:w<CR>") -- Save with Ctrl+s
map("v", "<C-s>", "<Esc>:w<CR>") -- Save with Ctrl+s

map("v", "<C-c>", "y") -- Copy selection with Ctrl+c

map({ "n", "v" }, "<Tab>", ":wincmd w<CR>") -- Buffer Navigation

-- Indentation keybindings
map("n", "<C-,>", "<<")
map("n", "<C-.>", ">>")

map("i", "<C-,>", "<C-d>")
map("i", "<C-.>", "<C-t>")

map("v", "<C-,>", "<gv")
map("v", "<C-.>", ">gv")

-- Comment-out keybindings
map("n", "<C-/>", "<Cmd>normal gcc<CR>", { silent = true })
map("v", "<C-/>", "<Cmd>normal gcgv<CR>", { silent = true })
map("i", "<C-/>", "<Esc><Cmd>normal gcc<CR>i", { silent = true })

--- Yazi keybindings
map({ "n", "v" }, "<space><space>", "<Cmd>Yazi<CR>") -- Open yazi at current file
map("n", "<space>cw", "<Cmd>Yazi cwd<CR>") -- Open yazi in working directory

-- Directory tree keybindings
map({ "n", "v" }, "<F1>", "<Cmd>Neotree toggle<CR>")

-- Diagnostics
map({ "n", "v" }, "<F3>", "<cmd>Trouble diagnostics toggle<cr>")

-- Horizontal scrolling with Ctrl+MouseWheel
map({ "n", "v" }, "<C-ScrollWheelUp>", "5zh")
map({ "n", "v" }, "<C-ScrollWheelDown>", "5zl")
map("i", "<C-ScrollWheelUp>", "<C-o>5zh")
map("i", "<C-ScrollWheelDown>", "<C-o>5zl")

-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS

-- -- Buffer navigation keybindings (suppressed in diffview)
-- map("n", "<C-S-Left>", function()
-- 	local ft = vim.bo.filetype
-- 	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
-- 	if not vim.tbl_contains(diffview_fts, ft) then
-- 		vim.cmd("BufferPrevious")
-- 	end
-- end) -- Go to previous buffer
--
-- map("n", "<C-S-Right>", function()
-- 	local ft = vim.bo.filetype
-- 	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
-- 	if not vim.tbl_contains(diffview_fts, ft) then
-- 		vim.cmd("BufferNext")
-- 	end
-- end) -- Go to next buffer

-- Unified view state tracker
_G.active_side_view = nil

-- Helper function to close all side views
local function close_all_views()
	-- Close Neo-tree
	local neotree_ok, neotree_manager = pcall(require, "neo-tree.sources.manager")
	if neotree_ok then
		pcall(function()
			neotree_manager.close_all()
		end)
	end

	-- Close Undotree
	if vim.fn.exists(":UndotreeHide") == 2 then
		pcall(function()
			vim.cmd("UndotreeHide")
		end)
	end

	-- Close Diffview
	local diffview_ok, diffview_lib = pcall(require, "diffview.lib")
	if diffview_ok then
		local view = diffview_lib.get_current_view()
		if view then
			pcall(function()
				vim.cmd("DiffviewClose")
			end)
		end
	end

	-- Close Copilot Chat
	local copilot_ok, copilot = pcall(require, "CopilotChat")
	if copilot_ok and copilot.chat and copilot.chat:visible() then
		pcall(function()
			vim.cmd("CopilotChatClose")
		end)
	end
end

-- Unified toggle function (make it global so copilot-chat can use it)
_G.toggle_view = function(view_name, open_fn)
	if _G.active_side_view == view_name then
		-- If this view is active, close it
		close_all_views()
		_G.active_side_view = nil
	else
		-- Close all views first, then open the requested one
		close_all_views()
		vim.schedule(function()
			open_fn()
			_G.active_side_view = view_name
		end)
	end
end

-- Neo-tree
map({ "n", "v" }, "<F1>", function()
	_G.toggle_view("neotree", function()
		vim.cmd("Neotree toggle")
	end)
end, { desc = "Toggle Neo-tree" })

-- Undotree
map({ "n", "v" }, "<F2>", function()
	_G.toggle_view("undotree", function()
		_G.undotree_toggle()
	end)
end, { desc = "Toggle Undotree" })

-- Diffview
map({ "n", "v" }, "<F4>", function()
	_G.toggle_view("diffview", function()
		vim.cmd("DiffviewFileHistory")
	end)
end, { desc = "Toggle Diffview" })

local function smart_close()
	local win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_win_get_buf(win)
	local buftype = vim.bo[current_buf].buftype
	local name = vim.fn.bufname(current_buf)
	local win_count = vim.fn.winnr("$")
	local copilot_ok, copilot = pcall(require, "CopilotChat")

	-- Handle special panels first (before other conditions)
	-- Check all windows (not just loaded buffers)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local b = vim.api.nvim_win_get_buf(win)
		local bufname = vim.api.nvim_buf_get_name(b):lower()
		local filetype = vim.bo[b].filetype

		if bufname:match("undotree") or filetype == "undotree" then
			vim.cmd("UndotreeToggle")
			return
		elseif bufname:match("diffview") or filetype:match("diffview") then
			vim.cmd("DiffviewClose")
			return
		end
	end

	-- Check Copilot Chat separately
	if copilot_ok and copilot.chat and copilot.chat:visible() then
		pcall(function()
			vim.cmd("CopilotChatClose")
		end)
		return
	end

	-- Handle scratch or unnamed buffers
	if
		name == ""
		or name:find("[Scratch]", 1, true)
		or name:find("[readonly]", 1, true)
		or name:match("%.git[\\/]*COMMIT_EDITMSG")
	then
		vim.cmd("close")
		return
	elseif name:find("[Quickfix list]", 1, true) then
		vim.cmd("cclose")
		return
	end

	-- Handle normal buffers
	if win_count > 1 and buftype:match("") then
		local ok = pcall(function()
			vim.cmd("close")
		end)
		if not ok then
			vim.cmd("bd")
		end
	else
		vim.cmd("bd")
	end
end

map({ "n", "v" }, "<C-w>", smart_close, { noremap = true, nowait = true })
map({ "n", "v" }, "q", smart_close, { noremap = true, nowait = true })

-- Keymap to toggle chat with F5 using unified view system
vim.keymap.set(
	{ "n", "v" },
	"<F5>",
	function()
		-- Use the global toggle_view function if available
		if _G.toggle_view then
			_G.toggle_view("copilot", function()
				local chat = require("CopilotChat")
				chat.open()
				-- Move window to the right
				vim.cmd("wincmd L")
				vim.wo.wrap = false
			end)
		end
	end --, { desc = "Toggle Copilot Chat", silent = true }
)

-- Ensure wrap stays off when switching windows
vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		local bufname = vim.api.nvim_buf_get_name(0)
		if not bufname:match("copilot%-") then
			vim.wo.wrap = false
		end
	end,
})

local term_buf = nil -- will store our terminal buffer
local term_win = nil -- will store the window id
local term_height = 12

-- Toggle a terminal split below with `
vim.keymap.set({ "n", "t" }, "`", function()
	-- If terminal window is open → close it
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end

	-- If terminal buffer doesn't exist → create it
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("belowright split")
		term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_height(term_win, term_height)
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
		return
	end

	-- Buffer exists → reopen it
	vim.cmd("belowright split")
	term_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_height(term_win, term_height)
	vim.api.nvim_win_set_buf(term_win, term_buf)

	-- optional: auto-enter insert mode
	vim.cmd("startinsert")
end, { noremap = true, silent = true })

-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
