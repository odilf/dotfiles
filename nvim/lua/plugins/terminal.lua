return {
	{
		'akinsho/toggleterm.nvim',
		event = "VimEnter",
		config = function()
			require("toggleterm").setup({
				size = 20,
				hide_numbers = true,
			})
		end,
	},
}
