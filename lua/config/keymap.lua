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
-- map('n', '<C-S>s', ':wa<CR>') -- Save all buffers with Ctrl+Alt+s If this is turned on, it will gives delays to the Ctrl+s keybinding

-- Terminals
map("n", "<F4>", ":qa!<CR>") -- Exit Neovim
map("v", "<C-c>", "y") -- Copy selection with Ctrl+c

map("n", "<Tab>", ":wincmd w<CR>")
-- Buffer navigation keybindings (suppressed in diffview)
map("n", "<C-S-Left>", function()
	local ft = vim.bo.filetype
	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
	if not vim.tbl_contains(diffview_fts, ft) then
		vim.cmd("bprev")
	end
end) -- Go to previous buffer

map("n", "<C-S-Right>", function()
	local ft = vim.bo.filetype
	local diffview_fts = { "DiffviewFiles", "DiffviewFileHistory", "diff" }
	if not vim.tbl_contains(diffview_fts, ft) then
		vim.cmd("bnext")
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
-- map("n", "<F1>", "<Cmd>Neotree toggle<CR>") -- Open yazi in current file
-- map("v", "<F1>", "<Cmd>Neotree toggle<CR>") -- Open yazi in current file

-- Undotree
map("n", "<F2>", function()
	_G.undotree_toggle()
end, { desc = "Toggle Undotree" }) -- Toggle undotree
map("v", "<F2>", function()
	_G.undotree_toggle()
end, { desc = "Toggle Undotree" }) -- Toggle undotree

map("n", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")
map("v", "<F3>", "<cmd>Trouble diagnostics toggle<cr>")
map({ "n", "v" }, "<F5>", ":LazyGit<CR>")

map("n", "q", ":bd<CR>") -- Open symbols outline

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

-- Toggle function for Diffview
local function toggle_diffview()
	local view = require("diffview.lib").get_current_view()
	if view then
		-- If diffview is open, close it
		vim.cmd("DiffviewClose")
	else
		-- If diffview is closed, open it
		vim.cmd("DiffviewFileHistory")
	end
end

-- Diffview keybinding
map("n", "<F4>", toggle_diffview, { desc = "Toggle Diffview" })

-- Clear search on <Esc>
map("n", "<Esc>", function()
	vim.fn.setreg("/", "")
	vim.cmd("nohlsearch")
end)

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
