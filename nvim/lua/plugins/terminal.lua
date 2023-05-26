return {
	{
		'akinsho/toggleterm.nvim',
		lazy = false,
		config = function()
			require("toggleterm").setup({
				size = 20,
				hide_numbers = true,
			})
		end,
	},
}
