return {
	-- TODO: Use [proximity-sort](https://github.com/jonhoo/proximity-sort)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			-- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				extensions = {
					frecency = {
						db_safe_mode = false,
					}
				}
			})
			telescope.load_extension("frecency")
			-- TODO: Re-enable fzf in nixos
			-- telescope.load_extension("fzf")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		lazy = false, -- Bad to lazy load according to [docs](https://github.com/nvim-tree/nvim-tree.lua/wiki/Installation#lazy-loading)
		dependencies = {
			"nvim-tree/nvim-web-devicons",
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
		event = "BufRead",
		"Pocco81/auto-save.nvim",
		opts = {
			trigger_events = { "InsertLeave", "FocusLost", "TabLeave" },
		}
	},

	-- Search and replace in multiple files
	{
		"windwp/nvim-spectre",
	},
}
