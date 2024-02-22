return {
	{
		-- Mostly for quick commands, like `cargo add serde` or whatever
		'akinsho/toggleterm.nvim',
		event = "VimEnter",
		opts = {
			size = 20,
			hide_numbers = true,
			shell = "fish",
		}
	},
}
