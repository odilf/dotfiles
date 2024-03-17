--
return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"arkav/lualine-lsp-progress", -- look at the name
		},

		event = "VimEnter",

		opts = {
			extensions = {
				"nvim-tree",
			},
			options = {
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { { 'diagnostics', sources = { 'nvim_lsp' } } },
				lualine_c = { 'lsp_progress' },

				lualine_x = { 'branch', 'diff' },
				lualine_y = { 'location' },
				lualine_z = { 'filename' },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = { { 'diagnostics', sources = { 'nvim_lsp' } } },
				lualine_c = { 'lsp_progress' },

				lualine_x = { 'branch' },
				lualine_y = {},
				lualine_z = { 'filename' },
			},
		}
	}
}
