return {
	{
		-- Mostly for quick commands, like `cargo add serde` or whatever
		'akinsho/toggleterm.nvim',
		event = "VimEnter",
		opts = {
			size = 20,
			hide_numbers = true,
			shell = "fish",
		},
		keys = {
			{ "<leader>t,", "<cmd>ToggleTerm<enter>",                            desc = "Toggle terminal" },
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<enter>",            desc = "Floating terminal" },
			{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<enter>",       desc = "Horizontal terminal" },
			{ "<leader>tt", "<cmd>ToggleTerm direction=tab size=80<enter>",      desc = "Tab terminal" },
			{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<enter>", desc = "Vertical terminal" },
			{ "<esc>",      "<C-\\><C-n>",                                       desc = "Exit terminal mode", mode = "t" },
		}
	},
}
