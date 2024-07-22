-- folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99    -- start always unfolded

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context',
			'windwp/nvim-ts-autotag',
		},

		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = { enable = true, enable_autocmd = false },
			ensure_installed = {
				"bash",
				"c",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"query",
				"regex",
				"rust",
				"svelte",
				"tsx",
				"typescript",
				"vim",
				"wgsl",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-s>",
					node_incremental = "<C-s>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
			autotag = {
				enable = true,
			},
			rainbow = {
				enable = true,
			}
		},

		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
