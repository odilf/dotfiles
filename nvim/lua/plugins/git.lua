return {
	{
		'TimUntersberger/neogit',

		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			"nvim-telescope/telescope.nvim",
		},

		opts = {
			graph_style = "unicode",
			integrations = {
				telescope = true,
				diffview = true,
			}
		},

		cmd = "Neogit",
	},

	{
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
		},

		event = 'BufRead',
		cmd = "Gitsigns",
		opts = {}
	},

	{
		'tpope/vim-fugitive',
		event = 'BufWrite',
		cmd = 'Git'
	}
}
