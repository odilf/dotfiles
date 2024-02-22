return {
	{
		'TimUntersberger/neogit',

		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
		},

		opts = {
			integrations = {
				diffview = true,
			}
		}
	},

	{
		'lewis6991/gitsigns.nvim',

		requires = {
			'nvim-lua/plenary.nvim',
		},
		-- event = 'BufRead',
		cmd = "Gitsigns"
	}
}
