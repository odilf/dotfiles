vim.o.sessionoptions = "blank,buffers,curdir,folds,globals,help,tabpages,winsize,winpos,terminal,localoptions"

return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {}
	},
}
