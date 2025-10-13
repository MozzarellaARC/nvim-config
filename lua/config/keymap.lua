local map = vim.keymap.set

-- Disable default keybindings
map({ "n", "i", "v" }, "<C-r>", "<Nop>")
map({ "n", "v" }, "h", "<Nop>")
map({ "n", "v" }, "j", "<Nop>")
map({ "n", "v" }, "k", "<Nop>")
map({ "n", "v" }, "l", "<Nop>")
map({ "n", "v" }, "Q", "<Nop>")

---General keybindings
map("n", "z", "u") -- undo with ��Lz��L
map("n", "<C-S-z>", "<C-r>") -- Redo with Shift+z

map("n", "<C-s>", ":w<CR>") -- Save with Ctrl+s
map("i", "<C-s>", "<Esc>:w<CR>") -- Save with Ctrl+s
map("v", "<C-s>", "<Esc>:w<CR>") -- Save with Ctrl+s

map("v", "<C-c>", "y") -- Copy selection with Ctrl+c

map({ "n", "v" }, "<Tab>", ":wincmd w<CR>")

-- Buffer navigation keybindings (suppressed in diffview)
map("n", "<C-S-Left>", function()
	local ft = vim.bo.filetype
	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
	if not vim.tbl_contains(diffview_fts, ft) then
		vim.cmd("BufferPrevious")
	end
end) -- Go to previous buffer

map("n", "<C-S-Right>", function()
	local ft = vim.bo.filetype
	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
	if not vim.tbl_contains(diffview_fts, ft) then
		vim.cmd("BufferNext")
	end
end) -- Go to next buffer

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
map("n", "<F1>", "<Cmd>Neotree toggle<CR>") -- Open yazi in current file
map("v", "<F1>", "<Cmd>Neotree toggle<CR>") -- Open yazi in current file

-- Undotree
map("n", "<F2>", function()
	_G.undotree_toggle()
end, { desc = "Toggle Undotree" }) -- Toggle undotree
map("v", "<F2>", function()
	_G.undotree_toggle()
end, { desc = "Toggle Undotree" }) -- Toggle undotree

-- Diagnostics
map("n", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")
map("v", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")

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
			copilot.close()
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

-- Directory tree keybindings
map("n", "<F1>", function()
	_G.toggle_view("neotree", function()
		vim.cmd("Neotree toggle")
	end)
end, { desc = "Toggle Neo-tree" })
map("v", "<F1>", function()
	_G.toggle_view("neotree", function()
		vim.cmd("Neotree toggle")
	end)
end, { desc = "Toggle Neo-tree" })

-- Undotree
map("n", "<F2>", function()
	_G.toggle_view("undotree", function()
		_G.undotree_toggle()
	end)
end, { desc = "Toggle Undotree" })
map("v", "<F2>", function()
	_G.toggle_view("undotree", function()
		_G.undotree_toggle()
	end)
end, { desc = "Toggle Undotree" })

map("n", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")
map("v", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")

-- Toggle function for Diffview
map("n", "<F4>", function()
	_G.toggle_view("diffview", function()
		vim.cmd("DiffviewFileHistory")
	end)
end, { desc = "Toggle Diffview" })

-- Copilot Chat (F5 is defined in copilot-chat.lua but uses the same system)

-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS

-- Buffer deleteion Conditional
map("n", "<C-w>", function()
	-- Get the number of windows in current tab
	local win_count = vim.fn.winnr("$")
	-- Also check if current window is the last "normal" window
	-- (excluding special windows like quickfix, help, etc.)
	local current_win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(current_win)
	local buftype = vim.bo[buf].buftype
	if win_count > 1 and buftype == "" then
		-- Multiple windows and current is a normal buffer: close current window
		local ok = pcall(function()
			vim.cmd("close")
		end)
		if not ok then
			-- If close fails, fallback to deleting buffer
			vim.cmd("bd")
		end
	else
		-- Single window or special buffer type: delete buffer
		vim.cmd("bd")
	end
end, { noremap = true, nowait = true })

-- Clear search on <Esc>
map("n", "<Esc>", function()
	vim.fn.setreg("/", "")
	vim.cmd("nohlsearch")
end)

-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
-- IONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUU
-- FUNCTIONS, FUNCTIOS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS, FUNCTIONS
