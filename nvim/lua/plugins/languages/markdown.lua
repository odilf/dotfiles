return {
	{

		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && pnpm install",
		ft = { "markdown" },
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},

	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
			-- configuration here or empty for defaults
		},
	},

	{
		"OXY2DEV/markview.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- Used by the code bloxks
		},
		opts = {},
	},

	{
		"zk-org/zk-nvim",
		opts = {
			picker = "telescope",
			auto_attach = {
				enabled = true,
				filetypes = { "markdown" },
			},
		},
		ft = { "markdown" },
		config = function(_, opts)
			require("zk").setup(opts)
		end,
	},
}
