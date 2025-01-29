return {
	{
		'lewis6991/gitsigns.nvim',
		requires = {
			'nvim-lua/plenary.nvim',
		},

		event = 'BufRead',
		cmd = "Gitsigns",
		opts = {},
	},

	{
		'tpope/vim-fugitive',
		event = 'BufWrite',
		cmd = 'Git',
		keys = {
			{ "<leader>gb", "<cmd>Gitsigns blame_line<enter>",   desc = "Blame line" },
			{ "<leader>gc", "<cmd>Git commit<enter>",            desc = "Commit" },
			{ "<leader>gd", "<cmd>DiffviewOpen<enter>",          desc = "Open diff" },
			{ "<leader>gf", "<cmd>Gitsigns stage_buffer<enter>", desc = "Stage file" },
			{ "<leader>gg", "<cmd>Neogit<enter>",                desc = "Open neogit" },
			{ "<leader>gh", "<cmd>Gitsigns stage_hunk<enter>",   desc = "Stage hunk" },
			{ "<leader>gj", "<cmd>Gitsigns next_hunk<enter>",    desc = "Next hunk" },
			{ "<leader>gk", "<cmd>Gitsigns prev_hunk<enter>",    desc = "Previous hunk" },
		},
	}
}
