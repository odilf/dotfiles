return {
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false, -- Bad to lazy load according to [docs](https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation#lazy-loading)
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			{
				'b0o/nvim-tree-preview.lua',
				dependencies = {
					'nvim-lua/plenary.nvim',
				},
			},
		},
		keys = {
			{ "<leader>fe", "<cmd>NvimTreeToggle<enter>", desc = "Open tree file explorer" },
		},
		opts = {
			reload_on_bufenter = true,
			update_focused_file = {
				enable = true,
			},
			view = {
				centralize_selection = true,
			}
		},
	},

	{
		event = { "InsertLeave", "BufRead" },
		"okuuva/auto-save.nvim",
		cmd = "ASToggle",
		opts = {
			trigger_events = { "InsertLeave", "FocusLost", "TabLeave" },
		}
	},

	-- Search and replace in multiple files
	{
		"windwp/nvim-spectre",
		keys = {}
	},

	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		event = "BufRead",
		opts = { default_file_explorer = false },
	}
}
