return {
	{
		'mcauley-penney/visual-whitespace.nvim',
		opts = {},
		priority = 1100,
		event = "BufRead",
		config = function(_, config)
			require("visual-whitespace").setup(config)
			print("set hl")
			vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5D5F71", bg = "#24282d" })
			vim.api.nvim_set_hl(0, "VisualNonText", { link = "Visual" })
		end
	}
}
