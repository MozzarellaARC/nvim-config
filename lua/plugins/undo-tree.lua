return {
	{
		"mbbill/undotree",
		config = function()
			-- Enable persistent undo
			vim.opt.undofile = true
			vim.opt.undodir = vim.fn.expand("~/.vim/undodir")

			-- Create undodir if it doesn't exist
			local undodir = vim.fn.expand("~/.vim/undodir")
			if vim.fn.isdirectory(undodir) == 0 then
				vim.fn.mkdir(undodir, "p")
			end

			-- Create global function for undotree toggle
			_G.undotree_toggle = function()
				vim.cmd.UndotreeToggle()
			end
		end,
	},
}
