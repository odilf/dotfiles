return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,

		opts = {
			options = {
				ignore_focus = { "neo-tree", "neo-tree-popup", "notify" },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {
					{
						'diagnostics',
						sources = { 'nvim_lsp' },
					},
				},
				lualine_c = {},

				lualine_x = { 'fileformat', 'encoding' },
				lualine_y = { 'branch', 'diff' },
				lualine_z = { 'location', 'filename' },
			}
		}
	}
}
